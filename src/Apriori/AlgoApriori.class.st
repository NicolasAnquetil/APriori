"
L = frequentItemSets
"
Class {
	#name : #AlgoApriori,
	#superclass : #Object,
	#instVars : [
		'transactions',
		'C',
		'L',
		'minSupport',
		'frequentClass'
	],
	#category : #Apriori
}

{ #category : #accessing }
AlgoApriori >> C [
	^ C
]

{ #category : #accessing }
AlgoApriori >> C: anObject [
	C := anObject
]

{ #category : #accessing }
AlgoApriori >> L [
	^ L
]

{ #category : #accessing }
AlgoApriori >> L: anObject [
	L := anObject
]

{ #category : #accessing }
AlgoApriori >> candidates: k [
	
	| join |
	
	join := self L last asSet asArray.

	join := join collectWithIndex: [ :each :index | 
		((index+1) to: join size) collect: [ :index2 | 
			((join at: index) items union: (join at: index2) items) sorted ]].
	
	join := join flatten asSet select: [ :each | each asSet size = k ].
	^ join collect: [ :each | self createItemSetFrom: each ].
]

{ #category : #accessing }
AlgoApriori >> createItemSetFrom: aCollection [

	^ self frequentClass from: aCollection with: self

	"^ AEMFrequentAssociation from: aCollection with: self"
	
	"^ AEMFrequentItemSet new
		items: aCollection;
		apriori: self"
]

{ #category : #running }
AlgoApriori >> filterC [

	^ self C select: [ :each |
		each support >= self minSupport ]
]

{ #category : #running }
AlgoApriori >> findItemSets1 [

	C := self transactions flatCollectAsSet: #yourself.
	C := C collect: [ :each | self createItemSetFrom: {each} ].
	self transactions do: [ :transaction |
		self incrementCForTransacation: transaction ].

	^ self filterC.
]

{ #category : #accessing }
AlgoApriori >> frequenItemsetFor: array [ 
	
	^ self frequentItemSets detect: [ :each | each items = array ] ifNone: [ #() ]
]

{ #category : #accessing }
AlgoApriori >> frequentClass [
	^ frequentClass
]

{ #category : #accessing }
AlgoApriori >> frequentClass: anObject [
	frequentClass := anObject
]

{ #category : #accessing }
AlgoApriori >> frequentItemSets [

	^ self L flatten
]

{ #category : #accessing }
AlgoApriori >> frequentItemSetsWithSize: aSize [

	^ self frequentItemSets select: [ :each | each items size = aSize]
]

{ #category : #accessing }
AlgoApriori >> frequentItemSetsWithSupport: support [

	^ self frequentItemSets select: [ :each | each support = support ]
]

{ #category : #running }
AlgoApriori >> incrementCForTransacation: transaction [

	self C do: [ :each |
		(transaction includesAllOf: each items )
			ifTrue: [ each support: (each support + 1) ]]
]

{ #category : #initialization }
AlgoApriori >> initialize [ 

	C := OrderedCollection new.
	L := OrderedCollection new.
	
	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"
	self useFrequentItemSetClass
]

{ #category : #accessing }
AlgoApriori >> itemsInFrequentItemSetsWithSize: aSize [

	^ (self frequentItemSetsWithSize: aSize) collect: #items
]

{ #category : #accessing }
AlgoApriori >> minSupport [
	
	"1 is different of 1.0"
	
	"absolute, ex 1, 23, 21.6"
	(minSupport isInteger or: [ minSupport > 1 ])
		ifTrue: [ ^ minSupport ].

	"relative between 0 and 1, for 100% use 1.0"
	^ minSupport * self transactions size
]

{ #category : #accessing }
AlgoApriori >> minSupport: anObject [
	minSupport := anObject
]

{ #category : #running }
AlgoApriori >> run [

	"L = frequentItemSets"

	| k |
	
	"L1 = {frequent items}"
	k := 1.
	L add: self findItemSets1.

	[ (L at: k) notEmpty ] whileTrue: [
		"Ck+1 = candidates generated from Lk"
		C := self candidates: (k + 1).
		self transactions do: [ :transaction |
			self incrementCForTransacation: transaction ].
		
		L add: self filterC.
		k := k + 1 ]
]

{ #category : #accessing }
AlgoApriori >> subsetsFor: frequentItemSet [ 
	
	^ self frequentItemSets select: [ :each | frequentItemSet items includesAll: each items ]
]

{ #category : #accessing }
AlgoApriori >> transactions [
	^ transactions
]

{ #category : #accessing }
AlgoApriori >> transactions: anObject [
	transactions := anObject
]

{ #category : #accessing }
AlgoApriori >> useFrequentAssociationClass [

	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"

	frequentClass := AEMFrequentAssociation
]

{ #category : #accessing }
AlgoApriori >> useFrequentItemSetClass [

	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"

	frequentClass := AEMFrequentItemSet
]
