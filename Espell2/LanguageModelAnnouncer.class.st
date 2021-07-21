Class {
	#name : #LanguageModelAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'storedAnnouncements',
		'suspended',
		'private'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #triggering }
LanguageModelAnnouncer >> announce: anAnnouncement [
	self isSuspended 
		ifFalse: [ 
			self private announce: anAnnouncement.
			super announce: anAnnouncement ]
		ifTrue:[
			storedAnnouncements ifNotNil:[ storedAnnouncements add: anAnnouncement ]
		].
]

{ #category : #'as yet unclassified' }
LanguageModelAnnouncer >> isSuspended [
	^suspended ifNil: [ suspended := false ]
]

{ #category : #triggering }
LanguageModelAnnouncer >> methodRemoved: aMethodModel [ 

	self announce: (MethodRemoved methodRemoved: aMethodModel protocol: nil origin: aMethodModel parent)
]

{ #category : #'as yet unclassified' }
LanguageModelAnnouncer >> private [
	^private ifNil: [ private := Announcer new ]
]

{ #category : #triggering }
LanguageModelAnnouncer >> unsubscribe: anObject [
	self private unsubscribe: anObject.	
	super unsubscribe: anObject.

]
