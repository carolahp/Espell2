Class {
	#name : #CandleWithClassVarsDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> bootstrap [
	| candle classVars langAspect |
	"next line is to ensure the aspect gets uninstalled"
	candle := Role new.
	[ 
	classVars := ClassVarAspect for: CandleFromObjVLispClass.
	classVars install.
	langAspect := PhAspect new
		add:
			(PhAdvice new
				pointcut:
					(PhPointcut new
						receivers: 'CandleFromObjVLispLanguage';
						selectors: 'transform';
						context: #(#receiver));
				advice: [ :context | 
					| dog dict |
					dog := context receiver ensureClassNamed: 'Dog'.
					dict := dog perform: classVars fieldName.
					dict at: #Kingdom put: #animal ];
				type: #after);
				yourself.
	candle := CandleFromObjVLispLanguage
		newFromModel: self sources asFileReference
		withName: 'CandleWithClassVars'
		withEntryPoint:
			'
		System log: ''candle!''.
		System log: System tinyBenchmarks.
		System quit'.
	self
		assert: (candle classClass allInstVarNames includes: classVars fieldName).
	self assert: candle classClass classPool isDictionary.
	self
		assert: ((candle classNamed: #Dog) classPool at: #Kingdom) = #animal
	"candle generate.
	candle writeImage.
	candle imageInDisk executeInVM" ]
		ensure: [ candle destroy.
			classVars uninstall.
			langAspect uninstall ]
]

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> sources [
	^ '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin'.
]
