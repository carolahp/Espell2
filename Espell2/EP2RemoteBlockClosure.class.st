Class {
	#name : #EP2RemoteBlockClosure,
	#superclass : #EP2RemotePointer,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteBlockClosure class >> modelInstSpec [
	^ 3 "may be 1 too"
]

{ #category : #constants }
EP2RemoteBlockClosure class >> role [ 
	^ 'BlockClosure'
]

{ #category : #accessing }
EP2RemoteBlockClosure >> allInstVars [
	^ #()
]

{ #category : #'high-level-messages' }
EP2RemoteBlockClosure >> argumentNames [
	^ self target object argumentNames
]

{ #category : #accessing }
EP2RemoteBlockClosure >> basicSize [
	^ 0
]

{ #category : #'high-level-message' }
EP2RemoteBlockClosure >> body [ 
	^ self target object body
]

{ #category : #'high-level-messages' }
EP2RemoteBlockClosure >> bodyOffset [
	^ self target object bodyOffset 
]

{ #category : #'high-level-messages' }
EP2RemoteBlockClosure >> gtInspectorIn: aGLMCompositePresentation highlightInterval: aCollection [ 
	^ self target object gtInspectorIn: aGLMCompositePresentation highlightInterval: aCollection 

]

{ #category : #testing }
EP2RemoteBlockClosure >> isEPDASTBlockMirror [
	^ true
]

{ #category : #'high-level-message' }
EP2RemoteBlockClosure >> isPrimitive [ 
	^ self target object isPrimitive
]

{ #category : #accessing }
EP2RemoteBlockClosure >> layoutClass [ 
	^ EP2BlockLayout 
]

{ #category : #'high-level-messages' }
EP2RemoteBlockClosure >> methodClass [
	^ self target object methodClass
]

{ #category : #'high-level-message' }
EP2RemoteBlockClosure >> outerContext [ 
	^ self target object outerContext
]

{ #category : #accessing }
EP2RemoteBlockClosure >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self sourceCode;
		nextPutAll: '*'
]

{ #category : #'high-level-message' }
EP2RemoteBlockClosure >> sourceCode [
	^ self target object sourceCode
]

{ #category : #'high-level-messages' }
EP2RemoteBlockClosure >> sourceCodeWithClassAndSelector [
	^ self target object sourceCodeWithClassAndSelector
]
