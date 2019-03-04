Class {
	#name : #AEMFrequentItemSetTest,
	#superclass : #TestCase,
	#category : #'Apriori-Core'
}

{ #category : #tests }
AEMFrequentItemSetTest >> testSupportOfFrequentItemSet [
	| a | 
	a := AEMApriori new
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
		minSupport: 4;
		run.
	"We are looking for 4 occurrences or more"
	
	self assert: (a frequentItemSetFor: #(C D)) support equals: 4.
	
	
]

{ #category : #tests }
AEMFrequentItemSetTest >> testSupportOfFrequentItemSet2 [
	| a | 
	a := AEMApriori new
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
		minSupport: 1;
		run.
	"We are looking for 1 occurrence or more so 2 is in."
	self assert: (a frequentItemSetFor: #(B C D)) support equals: 2.
]
