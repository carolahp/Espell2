Class {
	#name : #CandleWithClassVarsDemo,
	#superclass : #Object,
	#category : #Espell2Metamodel
}

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> bootstrap [
	| candle classVars langAspect membrane |
	"next line is to ensure the aspect gets uninstalled"
	candle := Role new.
	[
	membrane := PhMembrane new.
	classVars := ClassVarAspect for: CandleFromObjVLispClass.
	langAspect := self languageAspect.
	classVars registerOn: membrane.
	langAspect registerOn: membrane.
	membrane deployOn: candle.
	candle := CandleFromObjVLispLanguage basicNew
		name: 'Candle';
		tonelPath: self sources asFileReference; 
		entryPointCode: 
		'System log: ''candle!''.
		System log: System tinyBenchmarks.
		System quit';
		yourself.
	candle initialize.
	self
		assert: (candle classClass allInstVarNames includes: classVars fieldName).
	self assert: candle classClass classPool isDictionary.
	self
		assert: ((candle classNamed: #Dog) classPool at: #Kingdom) = #animal
	"candle generate.
	candle writeImage.
	candle imageInDisk executeInVM" ]
		ensure: [ 
			candle destroy.
			membrane uninstall.
			
			"classVars uninstall."
			"langAspect uninstall" ]
]

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> languageAspect [

	^ PhAspect new
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
					dict := dog classPool.
					dict at: #Kingdom put: #animal ];
				type: #after);
				yourself.
]

{ #category : #bootstrapping }
CandleWithClassVarsDemo class >> sources [
	^ '/Users/carolina.hernandez/Documents/restaurado/bootstrap/language-definitions/ObjVLispMin'.
]
