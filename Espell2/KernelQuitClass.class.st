Class {
	#name : #KernelQuitClass,
	#superclass : #EP2MClass,
	#category : #'Espell2-Metamodel'
}

{ #category : #hooks }
KernelQuitClass >> extendWithMonticelloCustom: anEP2MCClassDefinition [ 
	^ self 
]

{ #category : #initialization }
KernelQuitClass >> initializeWithTemplateCustom: aClass [ 
	^ self 
]

{ #category : #'stubs creation' }
KernelQuitClass >> installStubCustom [
	self metaclass = self
		ifTrue: [ ^ self installMetacircularStub ].
	"first install the stub of my metaclass"
	self metaclass installStub.
	"instantiate my metaclass to create a stub of me"
	self remote: (self metaclass newStubWithFormat: self format).
	^ self remote
]

{ #category : #'accessing backend' }
KernelQuitClass >> metaclass [
	^ self parent classMetaclass
]
