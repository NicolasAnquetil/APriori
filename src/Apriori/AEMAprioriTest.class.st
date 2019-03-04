Class {
	#name : #AEMAprioriTest,
	#superclass : #TestCase,
	#instVars : [
		'apriori1',
		'apriori2'
	],
	#category : #Apriori
}

{ #category : #running }
AEMAprioriTest >> setUp [
	
	apriori1 := AEMApriori new
		transactions: self transactions1;
		minSupport: 2; "2/9 = 22%"
		run.

	apriori2 := AEMApriori new
		transactions: self transactions2;
		minSupport: 3;
		run
]

{ #category : #tests }
AEMAprioriTest >> testAssociationRules [

	| frequenItemSet assocRules assocRule |
	

	frequenItemSet := apriori2 frequenItemsetFor: #(D E).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size equals: 2.
	
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items equals: #(D).
	self assert: assocRule to items equals: #(E).
	self assert: assocRule confidence closeTo: 0.75s2.
	
	assocRule := assocRules detect: [ :each | each from items = #(E) ].
	self assert: assocRule from items equals: #(E).
	self assert: assocRule to items equals: #(D).
	self assert: assocRule confidence closeTo: 1.
	
	frequenItemSet := apriori2 frequenItemsetFor: #(B D).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(B) ].
	self assert: assocRule from items = #(B).
	self assert: assocRule to items = #(D).
	"self assert: (assocRule confidence closeTo: 0.83s2 precision: 0.01)."
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items = #(D).
	self assert: assocRule to items = #(B).
	self assert: assocRule confidence closeTo: 0.625s3.
	
	frequenItemSet := apriori2 frequenItemsetFor: #(A D).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(A) ].
	self assert: assocRule from items = #(A).
	self assert: assocRule to items = #(D).
	self assert: assocRule confidence closeTo: 0.8s2.
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items = #(D).
	self assert: assocRule to items = #(A).
	self assert: assocRule confidence closeTo: 0.5s2.
	
	frequenItemSet := apriori2 frequenItemsetFor: #(A E).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(A) ].
	self assert: assocRule from items = #(A).
	self assert: assocRule to items = #(E).
	self assert: assocRule confidence closeTo: 0.8s2.
	assocRule := assocRules detect: [ :each | each from items = #(E) ].
	self assert: assocRule from items = #(E).
	self assert: assocRule to items = #(A).
	"self assert: assocRule confidence closeTo: 0.666s3."
	
	frequenItemSet := apriori2 frequenItemsetFor: #(B E).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(B) ].
	self assert: assocRule from items = #(B).
	self assert: assocRule to items = #(E).
	"self assert: assocRule confidence closeTo: 0.66s2."
	assocRule := assocRules detect: [ :each | each from items = #(E) ].
	self assert: assocRule from items = #(E).
	self assert: assocRule to items = #(B).
	"self assert: assocRule confidence closeTo: 0.66s2."
	
	frequenItemSet := apriori2 frequenItemsetFor: #(C D).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(C) ].
	self assert: assocRule from items = #(C).
	self assert: assocRule to items = #(D).
	self assert: assocRule confidence closeTo: 0.8s2.
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items = #(D).
	self assert: assocRule to items = #(C).
	self assert: assocRule confidence closeTo: 0.5s2.
	
	frequenItemSet := apriori2 frequenItemsetFor: #(A D E).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 6.
	assocRule := assocRules detect: [ :each | each from items = #(A) ].
	self assert: assocRule from items = #(A).
	self assert: assocRule to items = #(D E).
	self assert: assocRule confidence closeTo: 0.8.
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items = #(D).
	self assert: assocRule to items = #(A E).
	self assert: assocRule confidence closeTo: 0.5s2.
	assocRule := assocRules detect: [ :each | each from items = #(E) ].
	self assert: assocRule from items = #(E).
	self assert: assocRule to items = #(A D).
	"self assert: assocRule confidence closeTo: 0.666s3."
	assocRule := assocRules detect: [ :each | each from items = #(A D) ].
	self assert: assocRule from items = #(A D).
	self assert: assocRule to items = #(E).
	self assert: assocRule confidence = 1.
	assocRule := assocRules detect: [ :each | each from items = #(A E) ].
	self assert: assocRule from items = #(A E).
	self assert: assocRule to items = #(D).
	self assert: assocRule confidence = 1.
	assocRule := assocRules detect: [ :each | each from items = #(D E) ].
	self assert: assocRule from items = #(D E).
	self assert: assocRule to items = #(A).
	"self assert: assocRule confidence closeTo: 0.66s2."
	
	frequenItemSet := apriori2 frequenItemsetFor: #(B D E).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 6.
	assocRule := assocRules detect: [ :each | each from items = #(B) ].
	self assert: assocRule from items = #(B).
	self assert: assocRule to items = #(D E).
	"self assert: assocRule confidence closeTo: 0.66s2."
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items = #(D).
	self assert: assocRule to items = #(B E).
	self assert: assocRule confidence = 0.5.
	assocRule := assocRules detect: [ :each | each from items = #(E) ].
	self assert: assocRule from items = #(E).
	self assert: assocRule to items = #(B D).
	"self assert: assocRule confidence closeTo: 0.66s2."
	assocRule := assocRules detect: [ :each | each from items = #(B D) ].
	self assert: assocRule from items = #(B D).
	self assert: assocRule to items = #(E).
	self assert: assocRule confidence closeTo: 0.8s2.
	assocRule := assocRules detect: [ :each | each from items = #(B E) ].
	self assert: assocRule from items = #(B E).
	self assert: assocRule to items = #(D).
	self assert: assocRule confidence = 1.
	assocRule := assocRules detect: [ :each | each from items = #(D E) ].
	self assert: assocRule from items = #(D E).
	self assert: assocRule to items = #(B).
	"self assert: assocRule confidence closeTo: 0.66s2."
	
	frequenItemSet := apriori2 frequenItemsetFor: #(A B).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(A) ].
	self assert: assocRule from items = #(A).
	self assert: assocRule to items = #(B).
	"self assert: assocRule confidence closeTo: 0.6s2."
	assocRule := assocRules detect: [ :each | each from items = #(B) ].
	self assert: assocRule from items = #(B).
	self assert: assocRule to items = #(A).
	self assert: assocRule confidence closeTo: 0.5s2.
	
	frequenItemSet := apriori2 frequenItemsetFor: #(B C).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size = 2.
	assocRule := assocRules detect: [ :each | each from items = #(B) ].
	self assert: assocRule from items = #(B).
	self assert: assocRule to items = #(C).
	self assert: assocRule confidence closeTo: 0.5s2.
	assocRule := assocRules detect: [ :each | each from items = #(C) ].
	self assert: assocRule from items = #(C).
	self assert: assocRule to items = #(B).
	self assert: assocRule confidence closeTo: 0.6s2.
]

{ #category : #tests }
AEMAprioriTest >> testAssociationRules2 [

	| frequenItemSet assocRules assocRule |
	
	frequenItemSet := apriori2 frequenItemsetFor: #(D E).
	assocRules := frequenItemSet associationRules.
	self assert: assocRules size equals: 2.
	assocRule := assocRules detect: [ :each | each from items = #(D) ].
	self assert: assocRule from items equals: #(D).
	self assert: assocRule to items equals: #(E).
	self assert: assocRule confidence closeTo: 0.75s2
	
]

{ #category : #tests }
AEMAprioriTest >> testFrequenItemSetsItems [
	| frequenItemSets |
	frequenItemSets := apriori1 itemsInFrequentItemSetsWithSize: 1.
	self
		assert: (frequenItemSets includesAll: #(#('1') #('2') #('3') #('4') #('5'))).
	frequenItemSets := apriori1 itemsInFrequentItemSetsWithSize: 2.
	self
		assert:
			(frequenItemSets
				includesAll: #(#('1' '2') #('1' '3') #('1' '5') #('2' '3') #('2' '4') #('2' '5'))).
	frequenItemSets := apriori1 itemsInFrequentItemSetsWithSize: 3.
	self
		assert: (frequenItemSets includesAll: #(#('1' '2' '3') #('1' '2' '5'))).
	frequenItemSets := apriori2 itemsInFrequentItemSetsWithSize: 1.
	self
		assert: (frequenItemSets includesAll: #(#(D) #(B) #(E) #(A) #(C))).
	frequenItemSets := apriori2 itemsInFrequentItemSetsWithSize: 2.
	self
		assert:
			(frequenItemSets
				includesAll: #(#(D E) #(B D) #(A D) #(A E) #(B E) #(C D) #(A B) #(B C))).
	frequenItemSets := apriori2 itemsInFrequentItemSetsWithSize: 3.
	self assert: (frequenItemSets includesAll: #(#(A D E) #(B D E)))
]

{ #category : #tests }
AEMAprioriTest >> testFrequenItemSetsSize [
	
	self assert: (apriori1 frequentItemSetsWithSize: 1) size = 5.
	self assert: (apriori1 frequentItemSetsWithSize: 2) size = 6.
	self assert: (apriori1 frequentItemSetsWithSize: 3) size = 2.
	self assert: (apriori1 frequentItemSetsWithSize: 4) size = 0.
	

	self assert: (apriori2 frequentItemSetsWithSize: 1) size = 5.
	self assert: (apriori2 frequentItemSetsWithSize: 2) size = 8.
	self assert: (apriori2 frequentItemSetsWithSize: 3) size = 2.
	self assert: (apriori2 frequentItemSetsWithSize: 4) size = 0.
]

{ #category : #tests }
AEMAprioriTest >> testFrequenItemSetsSupport [
	
	self assert: apriori1 frequentItemSets size = 13.
	self assert: (apriori1 frequentItemSetsWithSupport: 0) size = 0.
	self assert: (apriori1 frequentItemSetsWithSupport: 1) size = 0.
	self assert: (apriori1 frequentItemSetsWithSupport: 2) size = 7.
	self assert: (apriori1 frequentItemSetsWithSupport: 3) size = 0.
	self assert: (apriori1 frequentItemSetsWithSupport: 4) size = 3.
	self assert: (apriori1 frequentItemSetsWithSupport: 5) size = 0.
	self assert: (apriori1 frequentItemSetsWithSupport: 6) size = 2.
	self assert: (apriori1 frequentItemSetsWithSupport: 7) size = 1.
	self assert: (apriori1 frequentItemSetsWithSupport: 8) size = 0.
	self assert: (apriori1 frequentItemSetsWithSupport: 9) size = 0.
	self assert: (apriori1 frequentItemSetsWithSupport: 10) size = 0.
	
	
	self assert: apriori2 frequentItemSets size = 15.
	self assert: (apriori2 frequentItemSetsWithSupport: 0) size = 0.
	self assert: (apriori2 frequentItemSetsWithSupport: 1) size = 0.
	self assert: (apriori2 frequentItemSetsWithSupport: 2) size = 0.
	self assert: (apriori2 frequentItemSetsWithSupport: 3) size = 2.
	self assert: (apriori2 frequentItemSetsWithSupport: 4) size = 6.
	self assert: (apriori2 frequentItemSetsWithSupport: 5) size = 3.
	self assert: (apriori2 frequentItemSetsWithSupport: 6) size = 3.
	self assert: (apriori2 frequentItemSetsWithSupport: 7) size = 0.
	self assert: (apriori2 frequentItemSetsWithSupport: 8) size = 1.
	self assert: (apriori2 frequentItemSetsWithSupport: 9) size = 0.
	self assert: (apriori2 frequentItemSetsWithSupport: 10) size = 0.
]

{ #category : #accessing }
AEMAprioriTest >> transactions1 [

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

{ #category : #accessing }
AEMAprioriTest >> transactions2 [

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
