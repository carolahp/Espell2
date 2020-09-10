Class {
	#name : #EP2TonelRepository,
	#superclass : #TonelRepository,
	#instVars : [
		'metamodel'
	],
	#category : #'Espell2-Tonel'
}

{ #category : #accessing }
EP2TonelRepository >> metamodel [
	^ metamodel
]

{ #category : #accessing }
EP2TonelRepository >> metamodel: anEP2MLanguage [ 
	metamodel := anEP2MLanguage
]

{ #category : #accessing }
EP2TonelRepository >> versionReaderForFileNamed: aString do: aBlock [
	^ self
		readStreamForFileNamed: aString
		do: [:s | | readerClass |
			readerClass := (MCVersionReader readerClassForFileNamed: aString).
			readerClass = TonelReader ifTrue: [ readerClass := EP2TonelReader ].
			readerClass ifNotNil:
				[:class | | reader |
					reader := (class on: s fileName: (self pathForFileNamed: aString)) metamodel: self metamodel; yourself.
					aBlock value: reader]]
]
