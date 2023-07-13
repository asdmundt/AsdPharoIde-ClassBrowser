Class {
	#name : #ASDPORMagritteEditor,
	#superclass : #WAComponent,
	#instVars : [
		'contents',
		'model',
		'message'
	],
	#category : #'AsdPharoIde-ClassBrowser-Component'
}

{ #category : #accessing }
ASDPORMagritteEditor class >> browserClass [

	^ Smalltalk at:
			  ((Smalltalk hasClassNamed: #Browser) ifTrue: [ #Browser ]
					   ifFalse: [ #ASDPORPackageBasedBrowser ])
]

{ #category : #accessing }
ASDPORMagritteEditor class >> description [
	^ 'Smalltalk Code Browser'
]

{ #category : #'instance creation' }
ASDPORMagritteEditor class >> fullOnClass: aClass [
	^ self fullOnClass: aClass selector: nil
]

{ #category : #testing }
ASDPORMagritteEditor class >> version [
	^ 'v1.0.0'
]

{ #category : #actions }
ASDPORMagritteEditor >> accept [
	| save |
	WADevelopment ensureAuthorInitialsWith: [ :question |
		self request: question ].
	message := nil.
	save := contents.
	model contents: contents notifying: self.
	contents := save
]

{ #category : #actions }
ASDPORMagritteEditor >> addAccessor [
	| selClass tmpModelClass |
	selClass := self model selectedClass.
	"self halt."
	selClass
		ifNotNil: [ Transcript show: selClass.
			tmpModelClass := ASDPORModelCreateAccessors selClass: selClass.
			tmpModelClass selClass: selClass.
			tmpModelClass apllyingRefacturing.
			self model indicateInstanceMessages ]
]

{ #category : #hooks }
ASDPORMagritteEditor >> children [
^ Array with: self monacoComponent 
]

{ #category : #accessing }
ASDPORMagritteEditor >> columns [
	^ #( systemCategory class messageCategory message )
]

{ #category : #accessing }
ASDPORMagritteEditor >> contents [
	^ contents
]

{ #category : #accessing }
ASDPORMagritteEditor >> contents: aString [ 
	"the browser sends CRLF as line ending but Squeak wants CR"
	contents := GRPlatform current convertToSmalltalkNewlines: aString
]

{ #category : #hooks }
ASDPORMagritteEditor >> initialRequest: aRequest [

	| theClass |
	super initialRequest: aRequest.
		self session rootComponent class development ifTrue: [ 
							Transcript show:
									'#################initialRequest####################'
							].
	aRequest fields at: 'class' ifPresent: [ :className | 
			Smalltalk at: className asSymbol ifPresent: [ :class | 
					theClass := (aRequest fields includesKey: 'meta') ifTrue: [ 
							            class class ]
							            ifFalse: [ class ].
					self session rootComponent class development ifTrue: [ 
							Transcript show:
									'#################' , theClass , '####################'
							].
					self model setClass: theClass selector: nil.
					aRequest fields at: 'method' ifPresent: [ :selector | 
							self model setClass: theClass selector: selector asSymbol ]
					]
			]
]

{ #category : #initialization }
ASDPORMagritteEditor >> initialize [

	super initialize.
	self model: self class browserClass new.
	self session rootComponent class development ifTrue: [ 
			Transcript show:
					'#################' , self model printString
					, '####################'
			].

]

{ #category : #accessing }
ASDPORMagritteEditor >> model [
	^ model
]

{ #category : #accessing }
ASDPORMagritteEditor >> model: aBrowserModel [
	model notNil ifTrue: [ model removeDependent: self ].
	aBrowserModel notNil ifTrue: [ aBrowserModel addDependent: self ].
	model := aBrowserModel.
	contents := model contents
]

{ #category : #notifying }
ASDPORMagritteEditor >> notify: aString at: location in: sourceStream [
	message := aString allButLast: 3
]

{ #category : #rendering }
ASDPORMagritteEditor >> renderColumnsOn: html [
	html div class: 'columns'; with: [
		self columns do: [ :each |
			html form class: 'column'; with: [
				| array |
				array := self model perform: (each , 'List') asSymbol.
				html div: [
					html select
						size: 10;
						list: array;
						"Very ugly hack to intentionally not delegate to WAScriptGenerator.
						If we delegate to WAScriptGenerator and the script generator is jQuery
						then #onChange: will result in
						$.bind('change', function(){submit()});
						which will blow up because submit() will not defined"
						attributeAt: 'onchange' put: 'submit()';
						selected: (array
							at: (self model perform: (each, 'ListIndex') asSymbol)
							ifAbsent: [ nil ]);
						callback: [ :item |
							self model
								perform: (each, 'ListIndex:') asSymbol
								with: (array indexOf: item) ] ] ] ] ]
]

{ #category : #rendering }
ASDPORMagritteEditor >> renderContentOn: html [

	html div
		style: '';
		with:[
	self
		renderColumnsOn: html;
		renderModeButtonsOn: html;
		renderMessageOn: html;
		renderContentPaneOn: html
		]
]

{ #category : #rendering }
ASDPORMagritteEditor >> renderContentPaneOn: html [
	html form
		class: 'definition';
		with: [ html
				div: [ html hiddenInput
						id: #hiddenContents;
						value: self contents;
						callback: [ :aString | self contents: aString ].
					self renderMonacoComponentOn: html.
					html break.
					html submitButton
						value: 'accept';
						callback: [ self accept ];
						onClick:
							(JSStream
								on:
									'var monacoComp = document.getElementsByTagName(''textarea'');
					 $(''#hiddenContents'').val(monacoComp[0].value) 
')
					"	html submitButton on: #accept of: self" ] ].
	html document
		addLoadScript:
			(JSStream
				on:
					'var monacoComp = document.getElementsByTagName(''textarea'');
					monacoComp[0].addEventListener(''change'', loadValue); 
					monacoComp[0].addEventListener(''load'', loadValue); 
					function loadValue(){ $(''#hiddenContents'').val(monacoComp[0].value) }
')
]

{ #category : #rendering }
ASDPORMagritteEditor >> renderMessageOn: html [
	message isNil
		ifFalse: [ html strong: message ]
]

{ #category : #rendering }
ASDPORMagritteEditor >> renderModeButtonsOn: html [
	html form
		class: 'mode';
		with: [ html
				div: [ html submitButton
						callback: [ self showInstance ];
						value: 'instance'.
					html submitButton
						callback: [ self showHelp ];
						value: 'help'.
					html submitButton
						callback: [ self showClass ];
						value: 'class' .
					html submitButton
						callback: [ self addAccessor  ];
						value: 'Accessors' ].
					 ]
]

{ #category : #rendering }
ASDPORMagritteEditor >> renderMonacoComponentOn: html [
	html render: (MonacoComponent
				code: self contents
				language: MonacoLanguage smalltalk)
]

{ #category : #notifying }
ASDPORMagritteEditor >> select [
]

{ #category : #actions }
ASDPORMagritteEditor >> selectFrom: aPos to: anotherPos [
]

{ #category : #accessing }
ASDPORMagritteEditor >> selectionInterval [
	^ 1 to: 1
]

{ #category : #actions }
ASDPORMagritteEditor >> showClass [
	self model indicateClassMessages
]

{ #category : #actions }
ASDPORMagritteEditor >> showHelp [
	self model plusButtonHit
]

{ #category : #actions }
ASDPORMagritteEditor >> showInstance [
	self model indicateInstanceMessages
]

{ #category : #hooks }
ASDPORMagritteEditor >> states [
	^ Array with: model
]

{ #category : #hooks }
ASDPORMagritteEditor >> style [
	^ 'form, div.columns {
	padding: 2px;
	margin: 0;
}

form.column {
	padding: 0;
	width: 25%;
	float: left;
}
form.column select {
	width: 100%;
	border: 1px solid #aaa;
}

form.mode {
	clear: both;
}

form.definition textarea {
	width: 100%;
	height: 200px;
	border: 1px solid #aaa;
}'
]

{ #category : #accessing }
ASDPORMagritteEditor >> text [
	^ Text fromString: self contents
]

{ #category : #notifying }
ASDPORMagritteEditor >> update: aSymbol [
	contents := model contents
]

{ #category : #updating }
ASDPORMagritteEditor >> updateUrl: aUrl [
	super updateUrl: aUrl.
	self model selectedClass isNil ifFalse: [
		aUrl addField: 'class' value: self model selectedClass fullName.
		self model metaClassIndicated
			ifTrue: [ aUrl addField: 'meta' ] ].
	self model selectedMessageName isNil 
		ifFalse: [ aUrl addField: 'method' value: self model selectedMessageName ]
]
