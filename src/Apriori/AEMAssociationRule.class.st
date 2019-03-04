Class {
	#name : #AEMAssociationRule,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'frequentItemSet'
	],
	#category : #Apriori
}

{ #category : #comparing }
AEMAssociationRule >> = anAssocRule [

	^ (self from = anAssocRule from) and: [ self to = anAssocRule to ]
]

{ #category : #accessing }
AEMAssociationRule >> associations [

	^ self from associations, self to associations
]

{ #category : #accessing }
AEMAssociationRule >> associationsAsQuery [

	^ self associations collect: #asQueryForMinedAssociation
]

{ #category : #accessing }
AEMAssociationRule >> associationsAsString [

	^ self associations collect: #asString
]

{ #category : #accessing }
AEMAssociationRule >> classes [

	^ self deltaMethods collectAsSet: #className
]

{ #category : #accessing }
AEMAssociationRule >> commiters [

	^ self deltaMethods collectAsSet: #author
]

{ #category : #accessing }
AEMAssociationRule >> confidence [
	
	"
	conf = sup(X) / sup(A)     
	A -> X - A
	
	A=from
	X=frequentItemSet
	X-A=to
	"
	
	^ (self frequentItemSet support / self from support) asScaledDecimal 
]

{ #category : #accessing }
AEMAssociationRule >> dates [

	^ (self timestamps collectAsSet: #asDate) sorted
]

{ #category : #accessing }
AEMAssociationRule >> deltaMethods [

	^ (self systemHistory queryAssociations: self associationsAsQuery) methods sorted: [ :a :b | a timestamp < b timestamp ]
]

{ #category : #accessing }
AEMAssociationRule >> deltaMethodsForQuery [

	"find just the delta methods in my query"
	^ (self queryResult queryAssociations: self associationsAsQuery) methods sorted: [ :a :b | a timestamp < b timestamp ]
]

{ #category : #accessing }
AEMAssociationRule >> frequentItemSet [
	^ frequentItemSet
]

{ #category : #accessing }
AEMAssociationRule >> frequentItemSet: anObject [
	frequentItemSet := anObject
]

{ #category : #accessing }
AEMAssociationRule >> from [
	^ from
]

{ #category : #accessing }
AEMAssociationRule >> from: anObject [
	from := anObject
]

{ #category : #accessing }
AEMAssociationRule >> fromAsString [

	^ from associationsAsString
]

{ #category : #comparing }
AEMAssociationRule >> hash [ 
	
	^ self from hash + self to hash
]

{ #category : #validation }
AEMAssociationRule >> match: aDeltaMethod [ 
	
	^ (self from matchDeletedAssociations: aDeltaMethod deletedAssociationsAsQueryForValidation) and: [
		self to matchAddedAssociations: aDeltaMethod addedAssociationsAsQueryForValidation]
]

{ #category : #experiments }
AEMAssociationRule >> overview [

	^ { self deltaMethods size. self revisions size. self dates size. self timeframeInDays}
]

{ #category : #printing }
AEMAssociationRule >> printOn: aStream [
	
	self from printOn: aStream.
	self to printOn: aStream
]

{ #category : #accessing }
AEMAssociationRule >> queryResult [

	^ self frequentItemSet queryResult
]

{ #category : #accessing }
AEMAssociationRule >> relativeSupport [

	^ self frequentItemSet relativeSupport
]

{ #category : #accessing }
AEMAssociationRule >> revisions [

	"consider a windows of 5 minutes"

	^ AEMUtils revisionsFor: self timestamps
]

{ #category : #accessing }
AEMAssociationRule >> size [

	^ self frequentItemSet size	
]

{ #category : #accessing }
AEMAssociationRule >> support [

	^ self frequentItemSet support
]

{ #category : #accessing }
AEMAssociationRule >> systemHistory [

	^ self frequentItemSet systemHistory
]

{ #category : #accessing }
AEMAssociationRule >> timeframe [
	
	| dates firstFix lastFix |
	
	dates := self dates.
	firstFix := dates first.
	lastFix := dates last.
	^ lastFix - firstFix
]

{ #category : #accessing }
AEMAssociationRule >> timeframeInDays [
	
	^ self timeframe days
]

{ #category : #accessing }
AEMAssociationRule >> timestamps [

	"consider a windows of 5 minutes"

	^ self deltaMethods collect: #timestamp
]

{ #category : #accessing }
AEMAssociationRule >> to [
	^ to
]

{ #category : #accessing }
AEMAssociationRule >> to: anObject [
	to := anObject
]

{ #category : #accessing }
AEMAssociationRule >> toAsString [

	^ to associationsAsString
]
