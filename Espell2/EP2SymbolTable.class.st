Class {
	#name : #EP2SymbolTable,
	#superclass : #Object,
	#instVars : [
		'objectSpace'
	],
	#category : #'Espell2-Image'
}

{ #category : #public }
EP2SymbolTable >> at: aLocalSymbol [

	^ self at: aLocalSymbol ifAbsent: [ self error: 'key not found: ', aLocalSymbol ]
]

{ #category : #public }
EP2SymbolTable >> at: aLocalSymbol ifAbsent: aBlock [

	self symbolsDo: [ :remoteSymbol | remoteSymbol asLocalString = aLocalSymbol
		ifTrue: [ ^ remoteSymbol ] ].
	^ aBlock value
]

{ #category : #public }
EP2SymbolTable >> at: aLocalSymbol ifAbsentPut: aBlock [

	^ self at: aLocalSymbol ifAbsent: [ self installSymbol: aBlock value ]
]

{ #category : #public }
EP2SymbolTable >> includesKey: aLocalSymbol [

	self symbolsDo: [ :remoteSymbol | remoteSymbol asLocalString = aLocalSymbol 
		ifTrue: [ ^true ] ].
	^ false
]

{ #category : #public }
EP2SymbolTable >> installSymbol: aRemoteSymbol [
	self subclassResponsibility
]

{ #category : #accessing }
EP2SymbolTable >> objectSpace: anObjectSpace [

	objectSpace := anObjectSpace
]

{ #category : #public }
EP2SymbolTable >> symbolsDo: aBlock [
	self subclassResponsibility
]
