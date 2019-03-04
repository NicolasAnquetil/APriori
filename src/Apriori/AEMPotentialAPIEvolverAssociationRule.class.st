Class {
	#name : #AEMPotentialAPIEvolverAssociationRule,
	#superclass : #AEMAssociationRule,
	#category : #'Apriori-APIEvolver'
}

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> classes [

	^ self deltaMethods collectAsSet: #className
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> commiters [

	^ self deltaMethods collectAsSet: #author
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> dates [

	^ (self timestamps collectAsSet: #asDate) sorted
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> deltaMethods [

	^ (self systemHistory queryAssociations: self associationsAsQuery) methods sorted: [ :a :b | a timestamp < b timestamp ]
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> deltaMethodsForQuery [

	"find just the delta methods in my query"
	^ (self queryResult queryAssociations: self associationsAsQuery) methods sorted: [ :a :b | a timestamp < b timestamp ]
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> revisions [

	"consider a windows of 5 minutes"

	^ AEMUtils revisionsFor: self timestamps
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> systemHistory [

	^ self frequentItemSet systemHistory
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> timeframe [
	
	| dates firstFix lastFix |
	
	dates := self dates.
	firstFix := dates first.
	lastFix := dates last.
	^ lastFix - firstFix
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> timeframeInDays [
	
	^ self timeframe days
]

{ #category : #accessing }
AEMPotentialAPIEvolverAssociationRule >> timestamps [

	"consider a windows of 5 minutes"

	^ self deltaMethods collect: #timestamp
]
