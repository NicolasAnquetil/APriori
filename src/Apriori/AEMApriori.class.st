"
L = frequentItemSets
"
Class {
	#name : #AEMApriori,
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
AEMApriori >> C [
	^ C
]

{ #category : #accessing }
AEMApriori >> C: anObject [
	C := anObject
]

{ #category : #accessing }
AEMApriori >> L [
	^ L
]

{ #category : #accessing }
AEMApriori >> L: anObject [
	L := anObject
]

{ #category : #accessing }
AEMApriori >> candidates: k [
	
	| join |
	
	join := self L last asSet asArray.

	join := join collectWithIndex: [ :each :index | 
		((index+1) to: join size) collect: [ :index2 | 
			((join at: index) items union: (join at: index2) items) sorted ]].
	
	join := join flatten asSet select: [ :each | each asSet size = k ].
	^ join collect: [ :each | self createItemSetFrom: each ].
]

{ #category : #accessing }
AEMApriori >> createItemSetFrom: aCollection [

	^ self frequentClass from: aCollection with: self

	"^ AEMFrequentAssociation from: aCollection with: self"
	
	"^ AEMFrequentItemSet new
		items: aCollection;
		apriori: self"
]

{ #category : #running }
AEMApriori >> filterC [

	^ self C select: [ :each |
		each support >= self minSupport ]
]

{ #category : #running }
AEMApriori >> findItemSets1 [

	C := self transactions flatCollectAsSet: #yourself.
	C := C collect: [ :each | self createItemSetFrom: {each} ].
	self transactions do: [ :transaction |
		self incrementCForTransacation: transaction ].

	^ self filterC.
]

{ #category : #accessing }
AEMApriori >> frequenItemsetFor: array [ 
	
	^ self frequentItemSets detect: [ :each | each items = array ] ifNone: [ #() ]
]

{ #category : #accessing }
AEMApriori >> frequentClass [
	^ frequentClass
]

{ #category : #accessing }
AEMApriori >> frequentClass: anObject [
	frequentClass := anObject
]

{ #category : #accessing }
AEMApriori >> frequentItemSets [

	^ self L flatten
]

{ #category : #accessing }
AEMApriori >> frequentItemSetsWithSize: aSize [

	^ self frequentItemSets select: [ :each | each items size = aSize]
]

{ #category : #accessing }
AEMApriori >> frequentItemSetsWithSupport: support [

	^ self frequentItemSets select: [ :each | each support = support ]
]

{ #category : #running }
AEMApriori >> incrementCForTransacation: transaction [
	self C
		do: [ :each | 
			(transaction includesAll: each items)
				ifTrue: [ each support: each support + 1 ] ]
]

{ #category : #initialization }
AEMApriori >> initialize [ 

	C := OrderedCollection new.
	L := OrderedCollection new.
	
	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"
	self useFrequentItemSetClass
]

{ #category : #accessing }
AEMApriori >> itemsInFrequentItemSetsWithSize: aSize [

	^ (self frequentItemSetsWithSize: aSize) collect: #items
]

{ #category : #accessing }
AEMApriori >> minSupport [
	
	"1 is different of 1.0"
	
	"absolute, ex 1, 23, 21.6"
	(minSupport isInteger or: [ minSupport > 1 ])
		ifTrue: [ ^ minSupport ].

	"relative between 0 and 1, for 100% use 1.0"
	^ minSupport * self transactions size
]

{ #category : #accessing }
AEMApriori >> minSupport: anObject [
	minSupport := anObject
]

{ #category : #running }
AEMApriori >> run [

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
AEMApriori >> subsetsFor: frequentItemSet [ 
	
	^ self frequentItemSets select: [ :each | frequentItemSet items includesAll: each items ]
]

{ #category : #accessing }
AEMApriori >> transactions [
	^ transactions
]

{ #category : #accessing }
AEMApriori >> transactions: anObject [
	transactions := anObject
]

{ #category : #accessing }
AEMApriori >> useFrequentAssociationClass [

	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"

	frequentClass := AEMFrequentAssociation
]

{ #category : #accessing }
AEMApriori >> useFrequentItemSetClass [

	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"

	frequentClass := AEMFrequentItemSet
]
