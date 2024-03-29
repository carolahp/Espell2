Class {
	#name : #ObjVLispDemo,
	#superclass : #Object,
	#classInstVars : [
		'languageAspect',
		'fieldAspects',
		'membrane0',
		'membrane1',
		'membrane2',
		'language'
	],
	#category : #Espell2Metamodel
}

{ #category : #demo }
ObjVLispDemo class >> classVarsAndInstVarSlotsFromAspect [
	| result |
	fieldAspects := {(ClassVarsAspect for: ObjVLispMinClass).
	(InstVarSlotsAspect for: ObjVLispMinClass)}.
	languageAspect := LanguageAspect for: ObjVLispMinLanguage.
	self prepare.
	language := ObjVLispMinLanguage
		newFromModel: self sourcesPath
		withName: 'ObjVLispClassVarsAndSlots'
		withEntryPoint:
			'| p | 
	" Slots demo "
	p := Point new.
	(Point slotNamed: #x) write: 42 to: p.
	(Point slotNamed: #y) write: 12 to: p.
	System log: ((Point slotNamed: #x) read:p) asString.
	System log: ((Point slotNamed: #y) read:p) asString.
	" ClassVars demo "
	System log: Dog new kingdom asString.
	Dog new kingdom: #hola.
	System log: Dog new kingdom asString.	
	System quit'.
	[ self install.
	language build.
	result := language generateWriteAndExecute.
	self
		assert:
			result = '42
12
animal
hola' ]
		ensure: [ self uninstall ]
]

{ #category : #demo }
ObjVLispDemo class >> classVarsFromAspect [
	| result |
	fieldAspects := {ClassVarsAspect for: ObjVLispMinClass}.
	languageAspect := LanguageAspect for: ObjVLispMinLanguage.
	self prepare.
	language := ObjVLispMinLanguage
		newFromModel: self sourcesPath
		withName: 'ObjVLispClassVars'
		withEntryPoint: ClassVarsAspect demoEntryPoint.
	[ self install.
	language build.
	result := language generateWriteAndExecute.
	self assert: result = ClassVarsAspect expectedEntryPointResult ]
		ensure: [ self uninstall ]
]

{ #category : #demo }
ObjVLispDemo class >> instVarSlotsFromAspect [
	| result |
	fieldAspects := {InstVarSlotsAspect for: ObjVLispMinClass}.
	languageAspect := LanguageAspect for: ObjVLispMinLanguage.
	self prepare.
	language := ObjVLispMinLanguage
		newFromModel: self sourcesPath
		withName: 'ObjVLispInstVarSlots'
		withEntryPoint: InstVarSlotsAspect demoEntryPoint.
	[ self install.
	language build.
	result := language generateWriteAndExecute.
	self assert: result = InstVarSlotsAspect expectedEntryPointResult ]
		ensure: [ self uninstall ]
]

{ #category : #deploying }
ObjVLispDemo class >> install [
	self assert: languageAspect isNotNil.
	self assert: fieldAspects isNotNil.
	self assert: fieldAspects isNotEmpty.
	self assert: languageAspect fieldAspects isNotEmpty.
	self assert: membrane0 isNotNil.
	self assert: membrane1 isNotNil.
	self assert: membrane2 isNotNil.
	self assert: language isNotNil.
	
	fieldAspects do: [ :asp |
		asp registerOn: membrane1.
		asp registerOn: membrane2 ].
	languageAspect registerOn: membrane1.
	membrane0 deployOn: language
	"membrane0 install"
]

{ #category : #demo }
ObjVLispDemo class >> metaclassFromAspect [
	| result |
	fieldAspects := {MetaclassFieldAspect for: ObjVLispMinClass}.
	languageAspect := LanguageAspect for: ObjVLispMinLanguage.
	self prepare.
	language := ObjVLispMinLanguage
		newFromModel: self sourcesPath
		withName: 'ExplicitMetaclasses'
		withEntryPoint: '
	System log: Point metaclass name asString.
	System quit'.
	[ self install.
	language build.
	result := 'Class'.
	self assert: result = ClassVarsAspect expectedEntryPointResult ]
		ensure: [ self uninstall ]
]

{ #category : #deploying }
ObjVLispDemo class >> prepare [
	self assert: languageAspect isNotNil.
	self assert: fieldAspects isNotNil.

	languageAspect fieldAspects: fieldAspects asArray.
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1
]

{ #category : #accessing }
ObjVLispDemo class >> sourcesPath [
	^ '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin' asFileReference
]

{ #category : #demo }
ObjVLispDemo class >> superclassesFromAspect [
	| result |
	fieldAspects := {SuperclassesAspect for: ObjVLispMinClass}.
	languageAspect := LanguageAspect for: ObjVLispMinLanguage.
	self prepare.
	language := ObjVLispMinLanguage
		newFromModel: self sourcesPath
		withName: 'ObjVLispSuperclasses'
		withEntryPoint: '
	System log: Point superclasses asString.
	System quit'.
	[ self install.
	language build.
	result := '#()'.
	self assert: result = ClassVarsAspect expectedEntryPointResult ]
		ensure: [ self uninstall ]
]

{ #category : #deploying }
ObjVLispDemo class >> uninstall [
	fieldAspects
		do: [ :asp | 
			asp unregisterFrom: membrane1.
			asp unregisterFrom: membrane2 ].
	languageAspect unregisterFrom: membrane1.
	membrane1 unAdvise: membrane0.
	membrane2 unAdvise: membrane1.
	membrane0 undeployFrom: language.
	"membrane0 uninstall."
	PhAspectWeaver panicCleanAndResetAll.
	language destroy.
	fieldAspects := nil.
	languageAspect := nil.
	membrane0 := nil.
	membrane1 := nil.
	membrane2 := nil.
	language := nil
]
