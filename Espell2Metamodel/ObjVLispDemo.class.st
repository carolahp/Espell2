Class {
	#name : #ObjVLispDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #'as yet unclassified' }
ObjVLispDemo class >> classVarsFromAspect [
	| aspClass aspLang membrane0 membrane1 membrane2 objvlisp |
	aspClass := ClassVarAspect for: ObjVLispMinClass.
	aspLang := LanguageAspect for: ObjVLispMinLanguage.
	aspLang fieldAspects: {aspClass}.
	membrane0 := PhMembrane new.
	membrane1 := PhMembrane new advise: membrane0.
	membrane2 := PhMembrane new advise: membrane1.
	objvlisp := ObjVLispMinLanguage
		newFromModel:
			'/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin'
				asFileReference
		withName: 'ObjVLispClassVars'
		withEntryPoint:
			'System log: Dog new kingdom asString.
		Dog new kingdom: #hola.
		System log: Dog new kingdom asString.
		System quit'.
	
	[ aspClass registerOn: membrane1.
	aspClass registerOn: membrane2.
	aspLang registerOn: membrane1.
	membrane0 deployOn: objvlisp.
	objvlisp build.
	objvlisp generate.
	objvlisp writeImage executeInVM ]
		ensure: [ aspClass unregisterFrom: membrane1.
			aspClass unregisterFrom: membrane2.
			aspLang unregisterFrom: membrane1.
			membrane0 undeployFrom: objvlisp.
			objvlisp destroy ]
]
