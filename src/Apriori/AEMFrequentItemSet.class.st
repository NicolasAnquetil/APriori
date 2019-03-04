Class {
	#name : #AEMFrequentItemSet,
	#superclass : #Object,
	#instVars : [
		'support',
		'items',
		'apriori'
	],
	#category : #'Apriori-Core'
}

{ #category : #'instance creation' }
AEMFrequentItemSet class >> from: aCollection with: apriori [

	^ self new
		items: aCollection;
		apriori: apriori
]

{ #category : #accessing }
AEMFrequentItemSet >> apriori [
	^ apriori
]

{ #category : #accessing }
AEMFrequentItemSet >> apriori: anAlgo [
	apriori := anAlgo
]

{ #category : #accessing }
AEMFrequentItemSet >> associationRuleFrom: from [

	| to |
	to := apriori frequentItemSetFor: (self items difference: from items) sorted.
	(from notNil and: [to notNil ]) ifFalse: [ ^ nil ].
	^ AEMAssociationRule new
		from: from;
		to: to;
		frequentItemSet: self
]

{ #category : #accessing }
AEMFrequentItemSet >> associationRules [

	^ self subsets collect: [ :subset | self associationRuleFrom: subset]
]

{ #category : #initialization }
AEMFrequentItemSet >> initialize [
	super initialize.
	support := 0
]

{ #category : #accessing }
AEMFrequentItemSet >> items [
	^ items
]

{ #category : #accessing }
AEMFrequentItemSet >> items: anObject [
	items := anObject
]

{ #category : #printing }
AEMFrequentItemSet >> printOn: aStream [
	"aStream nextPutAll: 'Items: '."
	self items printOn: aStream
]

{ #category : #accessing }
AEMFrequentItemSet >> relativeSupport [
	self flag: #todo.
	^ (self support / self transactions size) asScaledDecimal
]

{ #category : #accessing }
AEMFrequentItemSet >> subsets [
	"Returns the subsets for the receiver."
	"remove itemsets with size equals to me and to 1"
	^ (self apriori subsetsFor: self) reject: [ :each | (each items size = self items size)]
]

{ #category : #accessing }
AEMFrequentItemSet >> support [
	^ support
]

{ #category : #accessing }
AEMFrequentItemSet >> support: anObject [
	support := anObject
]
