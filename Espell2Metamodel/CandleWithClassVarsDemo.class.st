Class {
	#name : #CandleWithClassVarsDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> bootstrap [
	| candle classVars |
	[ classVars := ClassVarsAspect new
		metamodel: CandleFromObjVLispLanguage classModel;
		yourself.
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
	"candle generate.
	candle writeImage.
	candle imageInDisk executeInVM" ]
		ensure: [ 
			candle destroy.
			classVars uninstall ]
]

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> sources [
	^ '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin'.
]
