Class {
	#name : #ASDPOClassBrowser,
	#superclass : #WATool,
	#instVars : [
		'contents',
		'model',
		'message',
		'monacoComponent'
	],
	#category : #'AsdPharoIde-ClassBrowser-Component'
}

{ #category : #accessing }
ASDPOClassBrowser class >> browserClass [

	^ Smalltalk at:
			  ((Smalltalk hasClassNamed: #Browser) ifTrue: [ #Browser ]
					   ifFalse: [ #ASDPORPackageBasedBrowser ])
]

{ #category : #accessing }
ASDPOClassBrowser class >> description [
	^ 'Smalltalk Code Browser'
]

{ #category : #'instance creation' }
ASDPOClassBrowser class >> fullOnClass: aClass [
	^ self fullOnClass: aClass selector: nil
]

{ #category : #'instance creation' }
ASDPOClassBrowser class >> fullOnClass: aClass selector: aSelector [
	^ self new model: (self browserClass new setClass: aClass selector: aSelector)
]

{ #category : #testing }
ASDPOClassBrowser class >> version [
	^ 'v1.0.0'
]

{ #category : #actions }
ASDPOClassBrowser >> accept [
	| save |
	WADevelopment ensureAuthorInitialsWith: [ :question |
		self request: question ].
	message := nil.
	save := contents.
	model contents: contents notifying: self.
	contents := save
]

{ #category : #actions }
ASDPOClassBrowser >> addAccessor [
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
ASDPOClassBrowser >> children [
^ Array with: self monacoComponent 
]

{ #category : #accessing }
ASDPOClassBrowser >> columns [
	^ #( systemCategory class messageCategory message )
]

{ #category : #accessing }
ASDPOClassBrowser >> contents [
	^ contents
]

{ #category : #accessing }
ASDPOClassBrowser >> contents: aString [ 
	"the browser sends CRLF as line ending but Squeak wants CR"
	contents := GRPlatform current convertToSmalltalkNewlines: aString
]

{ #category : #hooks }
ASDPOClassBrowser >> initialRequest: aRequest [
	| theClass |
	super initialRequest: aRequest.
	aRequest fields at: 'class' ifPresent: [ :className |
		Smalltalk at: className asSymbol ifPresent: [ :class |
			theClass := (aRequest fields includesKey: 'meta')
				ifTrue: [ class class ]
				ifFalse: [ class ].
			self model setClass: theClass selector: nil.
			aRequest fields at: 'method' ifPresent: [ :selector |
				self model setClass: theClass selector: selector asSymbol ] ] ]
]

{ #category : #initialization }
ASDPOClassBrowser >> initialize [

	super initialize.
	self model: self class browserClass new.
	self monacoComponent:
			(MonacoComponent code: self contents  language: MonacoLanguage smalltalk)
]

{ #category : #accessing }
ASDPOClassBrowser >> model [
	^ model
]

{ #category : #accessing }
ASDPOClassBrowser >> model: aBrowserModel [
	model notNil ifTrue: [ model removeDependent: self ].
	aBrowserModel notNil ifTrue: [ aBrowserModel addDependent: self ].
	model := aBrowserModel.
	contents := model contents
]

{ #category : #accessing }
ASDPOClassBrowser >> monacoComponent [

	^ monacoComponent
]

{ #category : #accessing }
ASDPOClassBrowser >> monacoComponent: anObject [

	monacoComponent := anObject
]

{ #category : #notifying }
ASDPOClassBrowser >> notify: aString at: location in: sourceStream [
	message := aString allButLast: 3
]

{ #category : #rendering }
ASDPOClassBrowser >> renderColumnsOn: html [
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
ASDPOClassBrowser >> renderContentOn: html [
	self
		renderColumnsOn: html;
		renderModeButtonsOn: html;
		renderMessageOn: html;
		renderContentPaneOn: html
]

{ #category : #rendering }
ASDPOClassBrowser >> renderContentPaneOn: html [
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
ASDPOClassBrowser >> renderMessageOn: html [
	message isNil
		ifFalse: [ html strong: message ]
]

{ #category : #rendering }
ASDPOClassBrowser >> renderModeButtonsOn: html [
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
ASDPOClassBrowser >> renderMonacoComponentOn: html [
	html render: (MonacoComponent
				code: self contents
				language: MonacoLanguage smalltalk)
]

{ #category : #notifying }
ASDPOClassBrowser >> select [
]

{ #category : #actions }
ASDPOClassBrowser >> selectFrom: aPos to: anotherPos [
]

{ #category : #accessing }
ASDPOClassBrowser >> selectionInterval [
	^ 1 to: 1
]

{ #category : #actions }
ASDPOClassBrowser >> showClass [
	self model indicateClassMessages
]

{ #category : #actions }
ASDPOClassBrowser >> showHelp [
	self model plusButtonHit
]

{ #category : #actions }
ASDPOClassBrowser >> showInstance [
	self model indicateInstanceMessages
]

{ #category : #hooks }
ASDPOClassBrowser >> states [
	^ Array with: model
]

{ #category : #hooks }
ASDPOClassBrowser >> style [
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
ASDPOClassBrowser >> text [
	^ Text fromString: self contents
]

{ #category : #notifying }
ASDPOClassBrowser >> update: aSymbol [
	contents := model contents
]

{ #category : #updating }
ASDPOClassBrowser >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	anHtmlRoot link
		beStylesheet;
		url: 'https://fonts.googleapis.com/css?family=Roboto'.
	anHtmlRoot javascript
		url:
			'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.15.6/min/vs/loader.js'.
	anHtmlRoot title: 'Monaco Demo - ' , self class version
]

{ #category : #updating }
ASDPOClassBrowser >> updateUrl: aUrl [
	super updateUrl: aUrl.
	self model selectedClass isNil ifFalse: [
		aUrl addField: 'class' value: self model selectedClass fullName.
		self model metaClassIndicated
			ifTrue: [ aUrl addField: 'meta' ] ].
	self model selectedMessageName isNil 
		ifFalse: [ aUrl addField: 'method' value: self model selectedMessageName ]
]
