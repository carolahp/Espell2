Class {
	#name : #EP2ExternalSymbolTable,
	#superclass : #EP2SymbolTable,
	#instVars : [
		'symbols'
	],
	#category : #'Espell2-Image'
}

{ #category : #public }
EP2ExternalSymbolTable >> at: aLocalSymbol [

	^ symbols at: aLocalSymbol
]

{ #category : #public }
EP2ExternalSymbolTable >> includesKey: aLocalSymbol [

	^ symbols includesKey: aLocalSymbol
]

{ #category : #initialization }
EP2ExternalSymbolTable >> initialize [

	super initialize.
	symbols := EPDictionary new.
]

{ #category : #public }
EP2ExternalSymbolTable >> installSymbol: aRemoteSymbol [

	^ symbols at: aRemoteSymbol asLocalString asSymbol put: aRemoteSymbol
]

{ #category : #public }
EP2ExternalSymbolTable >> symbolsDo: aBlock [

	symbols copy keysAndValuesDo: [ :key :value |
		aBlock value: value.
	]
]

{ #category : #accessing }
EP2ExternalSymbolTable >> toInternalSymbolTable [

	| internal |
	internal := EP2InternalSymbolTable new objectSpace: objectSpace.
	self symbolsDo: [ :symbol | 
		internal installSymbol: symbol ].
	objectSpace symbolTable: internal.
]
