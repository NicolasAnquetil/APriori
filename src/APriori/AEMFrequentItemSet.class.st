"
I'm the internal data structure used to represent the Apriori transaction database (list of items).
I have a backpointer to the algorithm so that I can ask more information (for example when association rules are created).
I have a support number (representing my occurence in the transactions).
If my support is 3 it means that among the transactions exactly 3 contain my items. 

In this database
(
	#(A B D E)
	#(B C D)
	#(A B D E)
	#(A C D E)
	#(B C D E)
	#(B D E)
	#(C D)
	#(A B C)
	#(A D E)
)

#(B C D) support is 2.
#(C D) support is 4.
 



I'm responsible for the creation of association rules (more to come here)
"
Class {
	#name : #AEMFrequentItemSet,
	#superclass : #Object,
	#instVars : [
		'support',
		'items',
		'apriori'
	],
	#category : #'APriori-Core'
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

{ #category : #accessing }
AEMFrequentItemSet >> at: anInt [
	^ items at: anInt
]

{ #category : #enumerating }
AEMFrequentItemSet >> do: aBlock [
	^ items do: aBlock
]

{ #category : #accessing }
AEMFrequentItemSet >> first: anInt [
	^ items first: anInt
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
	aStream nextPutAll: 'ItemSet: '.
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
