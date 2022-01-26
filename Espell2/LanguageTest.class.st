Class {
	#name : #LanguageTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'imageInMemory',
		'imageInDisk',
		'expectedResult',
		'entryPointCode',
		'repository'
	],
	#category : #'Espell2-Tests'
}

{ #category : #'external repository' }
LanguageTest >> gitRepoName [
	" Use ObjVLispMin sources by default "
	^ 'KernelExplicitMetaclasses'
]

{ #category : #'external repository' }
LanguageTest >> gitRepoUrl [
	^ 'https://github.com/carolahp/',self gitRepoName,'.git'
]

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

{ #category : #'model creation' }
LanguageTest >> languageModelClass [
	self subclassResponsibility 
]

{ #category : #'kernel creation' }
LanguageTest >> newImageInDisk [
	self newImageInMemory.
	model writeImage.
	^ imageInDisk := model imageInDisk.
]

{ #category : #'kernel creation' }
LanguageTest >> newImageInMemory [
	self newModel.
	model generate.
	^ imageInMemory := model imageInMemory
]

{ #category : #'kernel creation' }
LanguageTest >> newModel [
	model := self languageModelClass
		newFromModel: self sourcesPath asFileReference
		withName: self languageModelClass name
		withEntryPoint: entryPointCode.
	model build.
	^ model
]

{ #category : #running }
LanguageTest >> setUp [ 
	
	repository := IceRepository registry
				detect: [ :repo | repo name = self gitRepoName ]
				ifNone: [ (IceRepositoryCreator new
						addRemote: self gitRepoUrl;
						createRepository) register ].
]

{ #category : #'external repository' }
LanguageTest >> sourcesPath [
	^ repository location absolutePath pathString
]

{ #category : #running }
LanguageTest >> tearDown [ 
	
	model ifNotNil: [ model destroy ].
	"To do: unregister ice repository"
]
