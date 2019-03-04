Class {
	#name : #AEMAssociationRule,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'frequentItemSet'
	],
	#category : #'Apriori-Core'
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
AEMAssociationRule >> size [

	^ self frequentItemSet size	
]

{ #category : #accessing }
AEMAssociationRule >> support [

	^ self frequentItemSet support
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
