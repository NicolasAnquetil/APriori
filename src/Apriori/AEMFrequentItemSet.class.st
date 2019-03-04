Class {
	#name : #AEMFrequentItemSet,
	#superclass : #Object,
	#instVars : [
		'support',
		'items',
		'apriori'
	],
	#category : #Apriori
}

{ #category : #'as yet unclassified' }
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
AEMFrequentItemSet >> apriori: anObject [
	apriori := anObject
]

{ #category : #accessing }
AEMFrequentItemSet >> associationRuleFrom: from [

	| to |

	to := apriori frequenItemsetFor: (self items difference: from items) sorted.
	
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

	self items printOn: aStream
]

{ #category : #accessing }
AEMFrequentItemSet >> relativeSupport [

	^ (self support / self transactions size) asTruncatedFloat100
]

{ #category : #accessing }
AEMFrequentItemSet >> subsets [
	
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
