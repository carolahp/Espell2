Class {
	#name : #LanguageTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'imageInMemory',
		'imageInDisk',
		'expectedResult',
		'entryPointCode'
	],
	#category : #'Espell2-Tests'
}

{ #category : #'evaluate code' }
LanguageTest >> inInterpreterExecute: someCode [
	imageInMemory ifNil: [self newImageInMemory].
	^ (model evaluateMarking: someCode) asLocalString
]

{ #category : #'evaluate code' }
LanguageTest >> inInterpreterExecuteEntryPoint [
	^ self inInterpreterExecute: entryPointCode 
]

{ #category : #'evaluate code' }
LanguageTest >> inVMExecuteEntryPoint [
	self newImageInDisk.
	^ imageInDisk executeInVM
]

{ #category : #'instance creation' }
LanguageTest >> languageModelClass [
	self subclassResponsibility 
]

{ #category : #'language creation' }
LanguageTest >> newImageInDisk [
	self newImageInMemory.
	model writeImage.
	^ imageInDisk := model imageInDisk.
]

{ #category : #'language creation' }
LanguageTest >> newImageInMemory [
	self newModel.
	model generate.
	^ imageInMemory := model imageInMemory
]

{ #category : #'language creation' }
LanguageTest >> newModel [
	^ model := self languageModelClass
		newFromModel: self sourcesPath asFileReference
		withName: self languageModelClass name
		withEntryPoint: entryPointCode
]

{ #category : #'instance creation' }
LanguageTest >> sourcesPath [
	self subclassResponsibility 
]

{ #category : #'instance creation' }
LanguageTest >> tearDown [ 
	model ifNotNil: [ model destroy ] 
]
