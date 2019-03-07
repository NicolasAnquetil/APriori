Class {
	#name : #AEMUtils,
	#superclass : #Object,
	#category : #'APriori-Core'
}

{ #category : #'exporting-elements' }
AEMUtils class >> exportArguments: queries [
	
	^ queries allSatisfy: #argumentsIsNotAny
]

{ #category : #'exporting-elements' }
AEMUtils class >> exportReceiver: queries [
	
	^ queries allSatisfy: #receiverIsNotAny
]

{ #category : #'exporting-elements' }
AEMUtils class >> exportSignature: queries [
	
	^ queries allSatisfy: #signatureIsNotAny
]

{ #category : #'parsing-ast' }
AEMUtils class >> normalizePatterns: patterns [
	
	"if we want to abstract the receiver of one invocation, we should abstract for all invovations
	in order to have better result when mining"
	"Need to think about that. TODO"
	
	| abstractReceiver abstractSignature abstractArguments |
	
	abstractReceiver := patterns anySatisfy: [ :each | each first = AEMAssociation any ].
	abstractSignature := [patterns anySatisfy: [ :each | each second = AEMAssociation any ]] on: Error do: [false].
	abstractArguments := [patterns anySatisfy: [ :each | each third = AEMAssociation any ]] on: Error do: [false].

	^ patterns collect: [ :each |
		| normalized |
		normalized := OrderedCollection new.
		abstractReceiver 
			ifTrue: [ normalized add: AEMAssociation any ]
			ifFalse: [ normalized add: each first ].
			
		abstractSignature 
			ifTrue: [ normalized add: AEMAssociation any ]
			ifFalse: [ normalized add: ([each second] on: Error do: [ '' ]) ].
			
		abstractArguments 
			ifTrue: [ normalized add: AEMAssociation any ]
			ifFalse: [ normalized add: ([each third] on: Error do: [ '' ]) ].
			
		normalized asArray reject: #isEmpty ]
]

{ #category : #'parsing-ast' }
AEMUtils class >> parseAddedInput: aString [ 
	
	^ (self parseInput: aString) collect: [ :each | ({'a'}, each) asQuery ]
]

{ #category : #'parsing-ast' }
AEMUtils class >> parseDeletedInput: aString [ 
	
	^ (self parseInput: aString) collect: [ :each | ({'d'}, each) asQuery ]
]

{ #category : #'parsing-ast' }
AEMUtils class >> parseExpression: aString [ 
	
	| ast assocs stringToParse patterns |

	stringToParse := self withoutAnyToken: aString.
	
	ast := RBParser parseExpression: stringToParse.
	assocs := ast associations.
	patterns := assocs collect: #asPattern.
	
	patterns := self withAnyToken: patterns.
	^ patterns
	"TODO"
	"^ self normalizePatterns: patterns"

	
]

{ #category : #'parsing-ast' }
AEMUtils class >> parseInput: aString [ 
	
	^ [self parseExpression: aString] on: Error do: [ #() "self parseInvocations: aString" ]
]

{ #category : #'parsing-ast' }
AEMUtils class >> parseInvocations: invocations [	
	
	^ (((invocations asString copyReplaceAll: {Character cr} with: ' ') subStrings: '.') collect: [ :each | each subStrings: ' ' ]) select: #notEmpty
]

{ #category : #'opening-sourcecode' }
AEMUtils class >> readFile: aFileName [
	
	| content fileStream |
	
	[fileStream := FileStream fileNamed: self filePath, aFileName.
	content := fileStream contents ] ensure: [ fileStream close ].

	^ content
]

{ #category : #'opening-sourcecode' }
AEMUtils class >> readFile: aFileName filePath: filePath [
	
	| content fileStream |
	
	(aFileName isNil or: [ filePath isNil ]) ifTrue: [ ^ '' ].
	
	[fileStream := FileStream fileNamed: filePath, aFileName.
	content := fileStream contents ] ensure: [ fileStream close ].

	^ content
]

{ #category : #revision }
AEMUtils class >> revisionsFor: aListOfRevisions [

	"consider a windows of 5 minutes"

	| revisions5min revisions currentRevision |
	
	revisions := aListOfRevisions sorted.
	
	revisions5min := OrderedCollection new.
	
	currentRevision := OrderedCollection new.
	currentRevision add: revisions first.
	revisions5min add: currentRevision.
	
	revisions overlappingPairsDo: [ :first :second |
		
		"300 seconds = 5min"
		((second - first) asSeconds <= 300)
			ifTrue: [ 
				currentRevision add: second.
				"revisions5min add: currentRevision" ]
			ifFalse: [ 
				currentRevision := OrderedCollection new.
				currentRevision add: second.
				revisions5min add: currentRevision ]].
		
	^ revisions5min
]

{ #category : #'parsing-ast' }
AEMUtils class >> withAnyToken: aCollection [ 
	
	^ aCollection collect: [ :each |
	
		(each size = 3)
			ifTrue: [ each third replaceAll: '_ANY_' with: '?'].
		each replaceAll: '_ANY_' with: '?']
]

{ #category : #'parsing-ast' }
AEMUtils class >> withoutAnyToken: aString [ 
	
	^ aString copyReplaceAll: '?' with: '_ANY_'
]
