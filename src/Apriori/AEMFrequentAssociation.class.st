Class {
	#name : #AEMFrequentAssociation,
	#superclass : #Object,
	#instVars : [
		'support',
		'miningResult',
		'items',
		'apriori'
	],
	#category : #Apriori
}

{ #category : #'instance creation' }
AEMFrequentAssociation class >> from: bruteFrequentSets with: apriori [
	
	| associations |
	
	associations := bruteFrequentSets collect: [ :assoc |
		AEMAssociation from: (assoc subStrings: ' ') ].

	^ self new associations: associations
]

{ #category : #comparing }
AEMFrequentAssociation >> = aFrequenteItemset [

	^ self associations = aFrequenteItemset associations
]

{ #category : #accessing }
AEMFrequentAssociation >> apriori [
	^ apriori
]

{ #category : #accessing }
AEMFrequentAssociation >> apriori: anObject [
	apriori := anObject
]

{ #category : #printing }
AEMFrequentAssociation >> asStringButType [

	^ ((self associations inject: '' into: [ :conc :each | conc, each asStringButType, ' ' ]) copyReplaceAll: '?' with: '') trimBoth
]

{ #category : #accessing }
AEMFrequentAssociation >> associationRule [

	| from to |

	from := self findFrequentItemSetFor: self queryAsAssociations.
	to := self findFrequentItemSetFor: (self associations difference: self queryAsAssociations).
	
	(from notNil and: [to notNil ]) ifFalse: [ ^ nil ].
	
	(from equalsButType: to) ifTrue: [ ^ nil ].

	^ AEMAssociationRule new
		from: from;
		to: to;
		frequentItemSet: self
]

{ #category : #accessing }
AEMFrequentAssociation >> equalsButType: aFrequentItemSet [

	(self associations size ~= aFrequentItemSet size)
		ifTrue: [ ^ false ].
		
	^ self associations allSatisfy: [ :each |
		aFrequentItemSet associations anySatisfy: [ :each2 |
			each asStringButType = each2 asStringButType ]]
]

{ #category : #accessing }
AEMFrequentAssociation >> findFrequentItemSetFor: aCollection [

	^ self miningResult frequentItemSets 
		detect: [ :each | each includesInvocations: aCollection ] ifNone: [ nil ]
]

{ #category : #comparing }
AEMFrequentAssociation >> hash [

	^ self associations hash
]

{ #category : #accessing }
AEMFrequentAssociation >> includesInvocations: aListOfInvocations [

	^ self associations includesAllOf: aListOfInvocations
]

{ #category : #'initialize-release' }
AEMFrequentAssociation >> initialize [

	support := 0
]

{ #category : #accessing }
AEMFrequentAssociation >> items [

	^ self associations collect: #asString
]

{ #category : #accessing }
AEMFrequentAssociation >> items: anObject [
	items := anObject
]

{ #category : #accessing }
AEMFrequentAssociation >> miningResult [
	^ miningResult
]

{ #category : #accessing }
AEMFrequentAssociation >> miningResult: anObject [
	miningResult := anObject
]

{ #category : #printing }
AEMFrequentAssociation >> printOn: aStream [

	"aStream 
		nextPutAll: 'transactions: ', self transactions size asString;
		lf;
		nextPutAll: 'support: ', self support asString, ' (', self relativeSupport asString,')';
		lf."

	self associations do: [ :invoc | 
		invoc printOn: aStream.
		aStream lf. ].
]

{ #category : #accessing }
AEMFrequentAssociation >> queryAsAssociations [

	^ self miningResult queryAsAssociations
]

{ #category : #accessing }
AEMFrequentAssociation >> queryResult [

	^ self miningResult queryResult
]

{ #category : #accessing }
AEMFrequentAssociation >> relativeSupport [

	^ (self support / self transactions size) asTruncatedFloat100
]

{ #category : #accessing }
AEMFrequentAssociation >> support [
	^ support
]

{ #category : #accessing }
AEMFrequentAssociation >> support: anObject [
	support := anObject
]

{ #category : #accessing }
AEMFrequentAssociation >> systemHistory [

	^ self miningResult systemHistory
]

{ #category : #accessing }
AEMFrequentAssociation >> transactions [

	^ self miningResult queryResult methods
]
