Class {
	#name : #ObjVLispDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
ObjVLispDemo class >> classVarsFromAspect [
	| aspClass aspLang membrane0 membrane1 membrane2 objvlisp result |
	aspClass := ClassVarAspect for: ObjVLispMinClass.
	aspLang := LanguageAspect for: ObjVLispMinLanguage.
	aspLang fieldAspects: {aspClass}.
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	objvlisp := ObjVLispMinLanguage
		newFromModel: self sourcesPath asFileReference
		withName: 'ObjVLispClassVars'
		withEntryPoint: ClassVarAspect demoEntryPoint.
	
	[ aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	membrane0 deployOn: objvlisp.
	objvlisp build.
	objvlisp generate.
	result := objvlisp writeImage executeInVM.
	self assert: result = ClassVarAspect expectedEntryPointResult.
	Transcript show: 'ObjVLispClassVars successfully generated from Aspects and run. Result: ', result asString ]
		ensure: [ 
			aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: objvlisp.
			PhAspectWeaver panicCleanAndResetAll.
			objvlisp destroy ]
]

{ #category : #'as yet unclassified' }
ObjVLispDemo class >> instVarSlotsAndClassVarsFromAspect [
	| aspClass aspSlots aspLang membrane0 membrane1 membrane2 objvlisp result |
	aspSlots := InstVarSlotAspect for: ObjVLispMinClass.
	aspClass := ClassVarAspect for: ObjVLispMinClass.
	aspLang := LanguageAspect for: ObjVLispMinLanguage.
	aspLang fieldAspects: {aspClass . aspSlots}.
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	objvlisp := ObjVLispMinLanguage
		newFromModel: self sourcesPath asFileReference
		withName: 'ObjVLispInstVarSlots'
		withEntryPoint: '| p |
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
	
	[ 
	aspSlots registerOn: membrane1.
	aspSlots registerOn: membrane2.
	aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	membrane0 deployOn: objvlisp.
	objvlisp build.
	objvlisp generate.
	result := objvlisp writeImage executeInVM.
	self assert: result = (InstVarSlotAspect expectedEntryPointResult, 
										 ClassVarAspect expectedEntryPointResult).
	Transcript show: 'ObjVInstVarSlotsAndClassVars successfully generated from Aspects and run. Result: ', result asString ]
		ensure: [ 
			aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: objvlisp.
			PhAspectWeaver panicCleanAndResetAll.
			objvlisp destroy ]
]

{ #category : #'as yet unclassified' }
ObjVLispDemo class >> instVarSlotsFromAspect [
	| aspClass aspLang membrane0 membrane1 membrane2 objvlisp result |
	aspClass := InstVarSlotAspect for: ObjVLispMinClass.
	aspLang := LanguageAspect for: ObjVLispMinLanguage.
	aspLang fieldAspects: {aspClass}.
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	objvlisp := ObjVLispMinLanguage
		newFromModel: self sourcesPath asFileReference
		withName: 'ObjVLispInstVarSlots'
		withEntryPoint: InstVarSlotAspect demoEntryPoint.
	
	[ aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	membrane0 deployOn: objvlisp.
	objvlisp build.
	objvlisp generate.
	result := objvlisp writeImage executeInVM.
	self assert: result = InstVarSlotAspect expectedEntryPointResult.
	Transcript show: 'ObjVInstVarSlots successfully generated from Aspects and run. Result: ', result asString ]
		ensure: [ 
			aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: objvlisp.
			PhAspectWeaver panicCleanAndResetAll.
			objvlisp destroy ]
]

{ #category : #'as yet unclassified' }
ObjVLispDemo class >> sourcesPath [
	^ '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin'
]
