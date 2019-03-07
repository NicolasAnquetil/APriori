Class {
	#name : #BaselineOfAPriori,
	#superclass : #BaselineOf,
	#category : #BaselineOfAPriori
}

{ #category : #baselines }
BaselineOfAPriori >> baseline: spec [ 
	<baseline>

	spec for: #pharo do: [		
		spec package: 'APriori'.
		"spec package: 'Containers-KeyedTree-Tests' with: [ spec requires: #('Containers-KeyedTree') ]"
	]
]
