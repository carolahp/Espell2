Class {
	#name : #EP2ExternalContext,
	#superclass : #EP2Remote,
	#category : #Espell2
}

{ #category : #constants }
EP2ExternalContext class >> layoutClass [
	^ EP2ExternalContextLayout 
]

{ #category : #'accessing - private' }
EP2ExternalContext >> allInstVars [
	^#()
]

{ #category : #'accessing - private' }
EP2ExternalContext >> allTemps [

	^ #()
]

{ #category : #'accessing - private' }
EP2ExternalContext >> printOn: aStream [
	aStream 
		nextPutAll: '*an ExtContext (';
		print: self mirror asString;
		nextPutAll: ')*'
]
