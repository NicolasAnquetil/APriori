Class {
	#name : #AEMMethodDeltaTest,
	#superclass : #TestCase,
	#instVars : [
		'mtd'
	],
	#category : #Apriori
}

{ #category : #private }
AEMMethodDeltaTest >> methodDelta [

	^ 'ClassOrganization,classify:under:suppressIfDefault:,MarcusDenker,1376059752,1381130479,ClassOrganization#classify$under$suppressIfDefault$#d#1376059752.sc,ClassOrganization#classify$under$suppressIfDefault$#a#1381130479.sc; o,new,model:,(''object''); o,self,protocolOrganizer,(); d,StandardWindow,new,(); a,window,newAutoAcceptTextEntryFor:get:set:,(nil#''object''#''object'');' subStrings: ';'
]

{ #category : #running }
AEMMethodDeltaTest >> setUp [

	| methodDelta |
	
	methodDelta := self methodDelta.
	
	mtd := AEMSystemHistory new addMethodDelta: methodDelta.
]

{ #category : #tests }
AEMMethodDeltaTest >> testAddedInvocations [

	self assert: mtd addedAssociations size = 1
]

{ #category : #tests }
AEMMethodDeltaTest >> testAttributes [

	self assert: mtd className = 'ClassOrganization'.
	self assert: mtd methodName = 'classify:under:suppressIfDefault:'.
	self assert: mtd author = 'MarcusDenker'.
	
	self assert: mtd oldRevision = '1376059752'.
	self assert: mtd newRevision = '1381130479'.
	
	self assert: mtd oldFileName = 'ClassOrganization#classify$under$suppressIfDefault$#d#1376059752.sc'.
	self assert: mtd newFileName = 'ClassOrganization#classify$under$suppressIfDefault$#a#1381130479.sc'.
	
	self assert: mtd associations size = 4.
	self assert: mtd deltaAssociations size = 2.
]

{ #category : #tests }
AEMMethodDeltaTest >> testDeletedAssociations [

	self assert: mtd deletedAssociations size = 1
]

{ #category : #tests }
AEMMethodDeltaTest >> testMatchAssociations [
	
	self assert: (mtd matchAssociation: #(d StandardWindow) asQuery ).
	self assert: (mtd matchAssociation: #(d StandardWindow ?) asQuery).
	self assert: (mtd matchAssociation: #(d StandardWindow ? ?) asQuery).
	self assert: (mtd matchAssociation: #(d StandardWindow new) asQuery).
	self assert: (mtd matchAssociation: #(d StandardWindow new ?) asQuery).
	
	self assert: (mtd matchAssociation: #(o new) asQuery).
	self assert: (mtd matchAssociation: #(o new ?) asQuery).
	self assert: (mtd matchAssociation: #(o new ? ?) asQuery).
	self assert: (mtd matchAssociation: #(o new model:) asQuery).
	self assert: (mtd matchAssociation: #(o new model: ?) asQuery).
	
	self assert: (mtd matchAssociation: #(a window) asQuery).
	self assert: (mtd matchAssociation: #(a window ?) asQuery).
	self assert: (mtd matchAssociation: #(a window ? ?) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set:) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: ?) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(? ? ?)) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(nil ? ?)) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(? '?' ?)) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(nil '?' ?)) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(? ? ?)) asQuery).
	self assert: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(nil ? ?)) asQuery).
	self deny: (mtd matchAssociation: #(a window newAutoAcceptTextEntryFor:get:set: #(? nil ?)) asQuery).
	
	
]

{ #category : #tests }
AEMMethodDeltaTest >> testOriginalAssociations [

	self assert: mtd originalAssociations size = 2
]
