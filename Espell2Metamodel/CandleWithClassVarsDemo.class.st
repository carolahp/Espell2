Class {
	#name : #CandleWithClassVarsDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> bootstrap [
	| candle classVars |
	"next line is to ensure the aspect gets uninstalled"
	candle := Role new.
	[ 
	classVars := ClassVarsAspect for: CandleFromObjVLispLanguage classModel.
	classVars install.
	
	candle := CandleFromObjVLispLanguage
		newFromModel: self sources asFileReference
		withName: 'CandleWithClassVars'
		withEntryPoint:
			'
		System log: ''candle!''.
		System log: System tinyBenchmarks.
		System quit'.
	self assert: (candle classClass allInstVarNames includes: classVars classVarsIVName).
	Transcript show: candle classClass allInstVarNames;cr.
	"candle generate.
	candle writeImage.
	candle imageInDisk executeInVM" ]
		ensure: [ 
			candle destroy.
			classVars uninstall
			 ]
]

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> sources [
	^ '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin'.
]
