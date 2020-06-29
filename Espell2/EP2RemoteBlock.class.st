Class {
	#name : #EP2RemoteBlock,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteBlock >> allInstVars [
	^ #()
]

{ #category : #'high-level-messages' }
EP2RemoteBlock >> argumentNames [
	^ self target object argumentNames
]

{ #category : #accessing }
EP2RemoteBlock >> basicSize [
	^ 0
]

{ #category : #'high-level-message' }
EP2RemoteBlock >> body [ 
	^ self target object body
]

{ #category : #'high-level-messages' }
EP2RemoteBlock >> bodyOffset [
	^ self target object bodyOffset 
]

{ #category : #'high-level-messages' }
EP2RemoteBlock >> gtInspectorIn: aGLMCompositePresentation highlightInterval: aCollection [ 
	^ self target object gtInspectorIn: aGLMCompositePresentation highlightInterval: aCollection 

]

{ #category : #testing }
EP2RemoteBlock >> isEPDASTBlockMirror [
	^ true
]

{ #category : #'high-level-message' }
EP2RemoteBlock >> isPrimitive [ 
	^ self target object isPrimitive
]

{ #category : #accessing }
EP2RemoteBlock >> layoutClass [ 
	^ EP2BlockLayout 
]

{ #category : #'high-level-messages' }
EP2RemoteBlock >> methodClass [
	^ self target object methodClass
]

{ #category : #'high-level-message' }
EP2RemoteBlock >> outerContext [ 
	^ self target object outerContext
]

{ #category : #accessing }
EP2RemoteBlock >> printOn: aStream [
	aStream 
		nextPutAll: '*';
		nextPutAll: self sourceCode;
		nextPutAll: '*'
]

{ #category : #'high-level-message' }
EP2RemoteBlock >> sourceCode [
	^ self target object sourceCode
]

{ #category : #'high-level-messages' }
EP2RemoteBlock >> sourceCodeWithClassAndSelector [
	^ self target object sourceCodeWithClassAndSelector
]
