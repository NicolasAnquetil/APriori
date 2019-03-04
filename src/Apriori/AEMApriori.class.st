"
I implement the Apriori learning algorithm https://en.wikipedia.org/wiki/Apriori_algorithm.
I should get a list of transactions (basically arrays of elements) and a minimum number of occurrences that I should consider.
Then I'm ready to run using the message run. 

Here is an example how to create and run the algorithm. It shows the three main public messages to get done with me: transactions:, minSupport: and run.

[[
AEMApriori new
		transactions: #(
							#('1' '2' '5')
							#('2' '4')
							#('2' '3')
							#('1' '2' '4')
							#('1' '3')
							#('2' '3')
							#('1' '3')
							#('1' '2' '3' '5')
							#('1' '2' '3'));
		minSupport: 2; ""2/9 = 22%""
		run.
]]]



Implementation

Given a threshold minSupport, the Apriori algorithm identifies the item sets which are subsets of at least minSupport transactions (occurrences) in the database.


L is the frequentItemSets

I work with instance of the class FrequentItemSet.


"
Class {
	#name : #AEMApriori,
	#superclass : #Object,
	#instVars : [
		'transactions',
		'L',
		'minSupport',
		'frequentClass',
		'candidates'
	],
	#category : #'Apriori-Core'
}

{ #category : #example }
AEMApriori class >> apriori1 [
	<sampleInstance>
	
	^ AEMApriori new
		transactions: #(
							#('1' '2' '5')
							#('2' '4')
							#('2' '3')
							#('1' '2' '4')
							#('1' '3')
							#('2' '3')
							#('1' '3')
							#('1' '2' '3' '5')
							#('1' '2' '3'));
		minSupport: 2; "2/9 = 22%"
		run.
]

{ #category : #example }
AEMApriori class >> apriori2 [
	<sampleInstance>
	
	^ AEMApriori new
		transactions: #(
							#(A B D E)
							#(B C D)
							#(A B D E)
							#(A C D E)
							#(B C D E)
							#(B D E)
							#(C D)
							#(A B C)
							#(A D E));
		minSupport: 3; 
		run.
]

{ #category : #queries }
AEMApriori >> candidates: k [
	
	| join |
	join := L last asSet asArray.

	join := join collectWithIndex: [ :each :index | 
		((index + 1) to: join size) collect: [ :index2 | 
			((join at: index) items union: (join at: index2) items) sorted ]].
	
	join := (join flatCollect: [ :each | each ]) asSet select: [ :each | each asSet size = k ].
	^ join collect: [ :each | self createItemSetFrom: each ].
]

{ #category : #factory }
AEMApriori >> createItemSetFrom: aCollection [

	^ self frequentClass from: aCollection with: self


]

{ #category : #running }
AEMApriori >> findItemSets1 [
	candidates := self transactions flatCollectAsSet: #yourself.
	candidates := candidates collect: [ :each | self createItemSetFrom: {each} ].
	self transactions
		do: [ :transaction | self incrementSupportOfCandidatesForTransaction: transaction ].
	^ self selectCandidatesAboveMinSupport
]

{ #category : #accessing }
AEMApriori >> frequentClass [
	^ frequentClass
]

{ #category : #accessing }
AEMApriori >> frequentClass: anObject [
	frequentClass := anObject
]

{ #category : #queries }
AEMApriori >> frequentItemSetFor: array [ 
	self flag: #todo. "It looks like the order is really important. We should check that this is true"
	^ self frequentItemSets detect: [ :each | each items = array ] ifNone: [ #() ]
]

{ #category : #queries }
AEMApriori >> frequentItemSets [
	self flag: #todo. "frequentItemSets looks like returning all the potential frequentItemSets
	without taking the threshold into account."
	
	^ L flatCollect: [ :each | each ]
]

{ #category : #queries }
AEMApriori >> frequentItemSetsWithSize: aSize [
	"Return the item sets of size, aSize"
	
	^ self frequentItemSets select: [ :each | each items size = aSize]
]

{ #category : #queries }
AEMApriori >> frequentItemSetsWithSupport: aNumber [
	"Return the item sets of support, aNumber"
	
	^ self frequentItemSets select: [ :each | each support = aNumber ]
]

{ #category : #running }
AEMApriori >> incrementSupportOfCandidatesForTransaction: transaction [
	"Increment the support of all the candidates based on the given transaction"
	
	candidates
		do: [ :candidate | 
			(transaction includesAll: candidate items)
				ifTrue: [ candidate support: candidate support + 1 ] ]
]

{ #category : #initialization }
AEMApriori >> initialize [ 

	candidates := OrderedCollection new.
	L := OrderedCollection new.
	minSupport := 2.
	
	"by default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"
	self useFrequentItemSetClass
]

{ #category : #queries }
AEMApriori >> itemsInFrequentItemSetsWithSize: aSize [

	^ (self frequentItemSetsWithSize: aSize) collect: #items
]

{ #category : #accessing }
AEMApriori >> minSupport [
	"Not really good design but we will see."
	
	"absolute, ex 1, 23"
	(minSupport isInteger or: [ minSupport > 1 ])
		ifTrue: [ ^ minSupport ].

	"relative between 0 and 1, for 100% use 1.0"
	^ minSupport * self transactions size
]

{ #category : #'public API' }
AEMApriori >> minSupport: aNumber [
	"Pay attention aNumber can be an integer of a float. 
	an Integer is meant for absolute values and a float between [ 0 and 1[ is for percentage.
	Hence 1 is different of 1.0. Have a look at minSupport."
	minSupport := aNumber
]

{ #category : #'public API' }
AEMApriori >> run [
	"L = frequentItemSets"
	| k |
	"L1 = {frequent items}"
	k  := 1.
	L add: self findItemSets1.

	[ (L at: k) notEmpty ] whileTrue: [
		"Ck+1 = candidates generated from Lk"
		candidates := self candidates: (k + 1).
		self transactions do: [ :transaction |
			self incrementSupportOfCandidatesForTransaction: transaction ].
		
		L add: self selectCandidatesAboveMinSupport.
		k := k + 1 ]
]

{ #category : #running }
AEMApriori >> selectCandidatesAboveMinSupport [

	^ candidates select: [ :each | each support >= self minSupport ]
]

{ #category : #queries }
AEMApriori >> subsetsFor: frequentItemSet [
	"Returns the subsets containing the elements of frequentItemSet"
	
	^ self frequentItemSets select: [ :each | frequentItemSet items includesAll: each items ]
]

{ #category : #accessing }
AEMApriori >> transactions [
	^ transactions
]

{ #category : #'public API' }
AEMApriori >> transactions: anObject [
	transactions := anObject
]

{ #category : #customization }
AEMApriori >> useFrequentAssociationClass [
	"By default use AEMFrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"

	frequentClass := AEMFrequentAssociation
]

{ #category : #customization }
AEMApriori >> useFrequentItemSetClass [
	"By default, use FrequentItemSet (#useFrequentItemSetClass), which is the classical frequent itemset for Apriori
	The other possibility is to use the class AEMFrequentAssociation (#useFrequentAssociationClass), which is used in APIEvolMiner"

	frequentClass := AEMFrequentItemSet
]
