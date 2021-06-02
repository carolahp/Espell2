Class {
	#name : #LanguageModelAnnouncer,
	#superclass : #Announcer,
	#category : #'Espell2-Metamodel'
}

{ #category : #triggering }
LanguageModelAnnouncer >> methodRemoved: aMethodModel [ 
	self announce: (MethodRemoved methodRemoved: aMethodModel protocol: nil origin: nil)
]
