Class {
	#name : #AEMRule,
	#superclass : #AEMAssociationRule,
	#category : #'APriori-Core'
}

{ #category : #printing }
AEMRule >> printOn: aStream [
	
	aStream 
		nextPutAll: 'confidence: ', self confidence asString;
		lf;
		nextPutAll: 'support: ', self support asString, ' (', self relativeSupport asString, ')';
		lf.
	aStream 
		nextPutAll: 'from: '.
	self from associations do: [ :each | each printOn: aStream. aStream space ].
	aStream 
		lf;
		nextPutAll: 'to: '.
	self to associations do: [ :each | each printOn: aStream. aStream space ].
]
