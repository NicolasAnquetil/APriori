Class {
	#name : #AEMAssociationTest,
	#superclass : #TestCase,
	#category : #Apriori
}

{ #category : #tests }
AEMAssociationTest >> testCreateFromInvocation [

	| invocString |
	
	invocString := '1,47164362,1331756835,o,MCSliceMaker,window,new,model:,(''nil''),ns,11,MCSliceMaker#window#d#1331756835'.
	
	self shouldnt: (AEMAssociation createFromTokens: (invocString subStrings: ',')) raise: Exception.
	
	invocString := '50,47164362,1331756835,o,MCSliceMaker,window,okBtn,isDefault:,(''true''),ns,11,MCSliceMaker#window#d#1331756835'.
	
	self shouldnt: (AEMAssociation createFromTokens: (invocString subStrings: ',')) raise: Exception.
	
	invocString := '97,47164362,1331756835,o,MCSliceMaker,window,LayoutFrame,fractions:offsets:,(''object''#''object''),s,11,MCSliceMaker#window#d#1331756835'.
	
	self shouldnt: (AEMAssociation createFromTokens: (invocString subStrings: ',')) raise: Exception.
	
	invocString := '5,47164362,1331756835,o,MCSliceMaker,window,StandardWindow,new,(),s,11,MCSliceMaker#window#d#1331756835'.
	
	self shouldnt: (AEMAssociation createFromTokens: (invocString subStrings: ',')) raise: Exception.
]

{ #category : #tests }
AEMAssociationTest >> testMatch [

	| assoc |
	
	assoc := AEMAssociation new.
	assoc type: 'd'.
	assoc receiver: 'obj'.
	assoc signature: 'add:'.
	assoc arguments: #(1).
	
	self assert: (assoc matchAssociation: #(d obj) asQuery).
	self assert: (assoc matchAssociation: #(d 'obj') asQuery).
	self deny: (assoc matchAssociation: #(d ob) asQuery).
	self assert: (assoc matchAssociation: #(d obj #?) asQuery).
	self assert: (assoc matchAssociation: #(d obj #? #?) asQuery).
	self assert: (assoc matchAssociation: #(d obj #? #(#?)) asQuery).
	"self deny: (assoc matchAssociation: #(d obj #? #(#? #?)) asQuery)."
	
	self assert: (assoc matchAssociation: #(d #? add:) asQuery).
	self assert: (assoc matchAssociation: #(d #? add: #?) asQuery).
	self assert: (assoc matchAssociation: #(d #? add: #(#?)) asQuery).
	
	self assert: (assoc matchAssociation: #(d #? #? #(1)) asQuery).
	self assert: (assoc matchAssociation: #(d #? #? #?) asQuery).
	
	self assert: (assoc matchAssociation: #(d obj add:) asQuery).
	self assert: (assoc matchAssociation: #(d obj add: #?) asQuery).
	self assert: (assoc matchAssociation: #(d obj add: #(#?)) asQuery).
	
	self assert: (assoc matchAssociation: #(d obj add: #(1)) asQuery).
	"self deny: (assoc matchAssociation: #(d obj add: #(1 2)) asQuery)."
]

{ #category : #tests }
AEMAssociationTest >> testMatchArguments [

	| invoc |
	
	invoc := AEMAssociation new.
	invoc arguments: #(1 nil true).

	self assert: (invoc matchArguments: #(1 #? #?)).
	
	self assert: (invoc matchArguments: #(#? nil #?)).
	
	self assert: (invoc matchArguments: #(#? #? #?)).
	
	self assert: (invoc matchArguments: #(1 nil #?)).
	
	self assert: (invoc matchArguments: #(1 nil true)).
	
	self deny: (invoc matchArguments: #(1 nil false)).
]

{ #category : #tests }
AEMAssociationTest >> testPadRightTo [

	| invoc |
	
	invoc := AEMAssociation.

	self assert: (invoc padRight: #(1) to: 3) = #(1 #? #?).
	self assert: (invoc padRight: #(1 #?) to: 3) = #(1 #? #?).
	self assert: (invoc padRight: #(1 #? #?) to: 3) = #(1 #? #?).
	
	self assert: (invoc padRight: #(#? 2) to: 3) = #(#? 2 #?).
	self assert: (invoc padRight: #(#? 2 #?) to: 3) = #(#? 2 #?).
	
	self assert: (invoc padRight: #(#? #? 3) to: 3) = #(#? #? 3).
	
	self assert: (invoc padRight: #(1 2) to: 3) = #(1 2 #?).
	self assert: (invoc padRight: #(1 2 #?) to: 3) = #(1 2 #?).
	
	self assert: (invoc padRight: #(#? 2 3) to: 3) = #(#? 2 3).
	
	self assert: (invoc padRight: #(1 #? 3) to: 3) = #(1 #? 3).
	self assert: (invoc padRight: #(1 #? 3) to: 3) = #(1 #? 3).
	
	self assert: (invoc padRight: #(1 2 3) to: 3) = #(1 2 3).
	
	self deny: (invoc padRight: #(1) to: 2) = #(1 #? #?).
	self deny: (invoc padRight: #(1 #?) to: 4) = #(1 #? #?).
	self deny: (invoc padRight: #(1 #? #?) to: 5) = #(1 #? #?).
]

{ #category : #tests }
AEMAssociationTest >> testPaddedInvocation [

	self assert: (#(1) asQuery asArray = #(1 #? #? #?)).
	self assert: (#(1 #?) asQuery asArray = #(1 #? #? #?)).
	self assert: (#(1 #? #?) asQuery asArray = #(1 #? #? #?)).
	
	self assert: (#(#? 2) asQuery asArray = #(#? 2 #? #?)).
	self assert: (#(#? 2 #?) asQuery asArray = #(#? 2 #? #?)).
	
	self deny: (#(#? #? #()) asQuery asArray = #(#? #? 3 #?)).
	self assert: (#(#? #? #?) asQuery asArray = #(#? #? #? #?)).
	
	self assert: (#(1 2) asQuery asArray = #(1 2 #? #?)).
	self assert: (#(1 2 #?) asQuery asArray = #(1 2 #? #?)).

	self assert: (#(#? #? 2 #(#?)) asQuery asArray = #(#? #? 2 #(#?))).
	self assert: (#(#? 1 #? #(#?)) asQuery asArray) = #(#? 1 #? #(#?)).
	
	self assert: (#(#? 1 2 #(#?)) asQuery asArray = #(#? 1 2 #(#?))).
	self assert: (#(#? 1 2 #(#? #?)) asQuery asArray = #(#? 1 2 #(#? #?))).
	self assert: (#(#? 1 2 #(#? #? #?)) asQuery asArray = #(#? 1 2 #(#? #? #?))).
	
	
]

{ #category : #tests }
AEMAssociationTest >> testTryParseToObject [

	self assert: (AEMAssociation tryParseToObject: 'aString') isString.
	self assert: (AEMAssociation tryParseToObject: '   aString   ') isString.
	self assert: (AEMAssociation tryParseToObject: '''aString''') isString.
	self assert: (AEMAssociation tryParseToObject: '   ''aString''   ') isString.
	
	self assert: (AEMAssociation tryParseToObject: 'true') = true.
	self assert: (AEMAssociation tryParseToObject: '   true   ') = true.
	self assert: (AEMAssociation tryParseToObject: '''true''') = true.
	
	self assert: (AEMAssociation tryParseToObject: 'false') = false.
	self assert: (AEMAssociation tryParseToObject: '   false   ') = false.
	self assert: (AEMAssociation tryParseToObject: '''false''') = false.
	
	self assert: (AEMAssociation tryParseToObject: 'nil') isNil.
	self assert: (AEMAssociation tryParseToObject: '   nil   ') isNil.
	self assert: (AEMAssociation tryParseToObject: '''nil''') isNil.
	
	self assert: (AEMAssociation tryParseToObject: '1') isNumber.
	self assert: (AEMAssociation tryParseToObject: '   1   ') isNumber.
	self assert: (AEMAssociation tryParseToObject: '''1''') isNumber.
	
	self assert: (AEMAssociation tryParseToObject: '-1.234') isNumber.
	self assert: (AEMAssociation tryParseToObject: '   -1.234   ') isNumber.
	self assert: (AEMAssociation tryParseToObject: '''-1.234''') isNumber.
]
