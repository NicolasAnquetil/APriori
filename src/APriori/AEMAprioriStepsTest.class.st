Class {
	#name : #AEMAprioriStepsTest,
	#superclass : #TestCase,
	#instVars : [
		'apriori1',
		'apriori2'
	],
	#category : #'APriori-Core'
}

{ #category : #running }
AEMAprioriStepsTest >> ItemsSetsAsCollections: aCollectionOfItemsSets [
	^ aCollectionOfItemsSets collect: [ :itemSet | itemSet items ]
]

{ #category : #running }
AEMAprioriStepsTest >> asItemSet: aCollection [
	^ AEMFrequentItemSet from: aCollection with: nil
]

{ #category : #running }
AEMAprioriStepsTest >> asItemSets: aCollectionOfCollections [
	^ aCollectionOfCollections collect: [ :each | self asItemSet: each ]
]

{ #category : #running }
AEMAprioriStepsTest >> setUp [
	
	apriori1 := AEMApriori new
		transactions: self transactions1;
		minSupport: 3.

	apriori2 := AEMApriori new
		transactions: self transactions2;
		minSupport: 3.
]

{ #category : #tests }
AEMAprioriStepsTest >> testAprioriGenJoin2 [
	| L2 |
	apriori1 frequentItemSets: (OrderedCollection with: (self asItemSets:  #(('1')  ('2') ('3')))).
	L2 := apriori1 aprioriGenJoin: 2.

	self assert: L2 size equals: 3.
	self assert: ((self ItemsSetsAsCollections: L2) includesAll: #(('1' '2')  ('2' '3') ('1' '3'))).


]

{ #category : #tests }
AEMAprioriStepsTest >> testAprioriGenJoin3 [
	| L2 |
	apriori1 frequentItemSets: (OrderedCollection with: (self asItemSets:  #(('1' '2') ('1' '3') ('2' '3') ('2' '4')))).
	L2 := apriori1 aprioriGenJoin: 3.

	self assert: L2 size equals: 2.
	self assert: ((self ItemsSetsAsCollections: L2) includesAll: #(('1' '2' '3') ('2' '3' '4'))).

]

{ #category : #tests }
AEMAprioriStepsTest >> testFindItemSet1 [
	| L1 |
	L1 := apriori1 findItemSets1.
	self assert: L1 size equals: 3.
	self assert: ((self ItemsSetsAsCollections: L1) includesAll: #(('1')  ('2') ('3'))).
	
	L1 := apriori2 findItemSets1.
	self assert: L1 size equals: 5.
	self assert: ((self ItemsSetsAsCollections: L1) includesAll: #((A) (B) (C) (D) (E))).

]

{ #category : #running }
AEMAprioriStepsTest >> transactions1 [

	^ #(
		#('1' '2' '5')
		#('2' '4')
		#('2' '3')
		#('1' '2' '4')
		#('1' '3')
		#('2' '3')
		#('1' '3')
		#('1' '2' '3' '5')
		#('1' '2' '3'))
]

{ #category : #running }
AEMAprioriStepsTest >> transactions2 [

	^ #(
		#(A B D E)
		#(B C D)
		#(A B D E)
		#(A C D E)
		#(B C D E)
		#(B D E)
		#(C D)
		#(A B C)
		#(A D E))
]
