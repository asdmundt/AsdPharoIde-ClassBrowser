Class {
	#name : #ASDPOClassBrowser,
	#superclass : #WAComponent,
	#traits : 'TWithRootDialogComponent',
	#classTraits : 'TWithRootDialogComponent classTrait',
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
	selClass ifNotNil: [ 
			
			tmpModelClass := ASDPORModelCreateAccessors selClass: selClass.
			tmpModelClass selClass: selClass.
			tmpModelClass apllyingRefacturing.
			self model indicateInstanceMessages
			]
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
					theClass := (aRequest fields includesKey: 'meta') ifTrue: [ 
							            class class ]
							            ifFalse: [ class ].

					self model setClass: theClass selector: nil.
					aRequest fields at: 'method' ifPresent: [ :selector | 
							self model setClass: theClass selector: selector asSymbol ]
					]
			]
]

{ #category : #initialization }
ASDPOClassBrowser >> initialize [

	super initialize.
	self model: self class browserClass new.
	self session rootComponent class development ifTrue: [ 
			Transcript show:
					'#################' , self model printString , '####################'
			].
	self monacoComponent: (MonacoComponent code: self contents
					 language: MonacoLanguage smalltalk)
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

{ #category : #actions }
ASDPOClassBrowser >> removePackage [

	| selPackage |
	selPackage := self session selectedPackage.
	"self halt."
	selPackage ifNotNil: [ 
			(RPackage organizer packageNamed: selPackage name) removeFromSystem.
				self model indicateInstanceMessages
			]
]

{ #category : #rendering }
ASDPOClassBrowser >> renderColumnsOn: html [

	html div
		class: 'columns';
		with: [ 
			self columns do: [ :each | 
						html form
							class: 'column';
							with: [ 
								| array |
								array := self model perform: (each , 'List') asSymbol.
								html div: [ 
											html select
												class:each;
												size: 10;
												list: array;
												"Very ugly hack to intentionally not delegate to WAScriptGenerator.
						If we delegate to WAScriptGenerator and the script generator is jQuery
						then #onChange: will result in
						$.bind('change', function(){submit()});
						which will blow up because submit() will not defined"
												attributeAt: 'onchange'
												put: 'submit()';
												selected:
													(array at:
																 (self model perform: (each , 'ListIndex') asSymbol)
															 ifAbsent: [ nil ]);
												callback: [ :item | 
													self model perform: (each , 'ListIndex:') asSymbol
															with: (array indexOf: item)
													]
											]
								]
						]
			]
]

{ #category : #rendering }
ASDPOClassBrowser >> renderContentOn: html [

	html div
		id: 'classBrowser';
		with: [ 
			self
				renderColumnsOn: html;
				renderModeButtonsOn: html;
				renderMessageOn: html;
				renderContentPaneOn: html
			].

	html html: '<script type="text/javascript">'.
	html html: '	window.addEventListener("resize", jsResize);
							window.addEventListener("load", jsResize);'.
	html html: 'function jsResize() {'.
	html html: 'var ah 	= screen.availHeight;'.
	html html: 'var aw 	= screen.availWidth;'.
	html html: 'var mh 	= (ah - 400) + ''px'';'.
	html html: 'var th 	= (ah - 750) + ''px'';'.
	html html: 'var lw 	= (aw - 880) + ''px'';'.
	html html: 'var wlw 	= (aw - 400) + ''px'';'.
	html html:
			'document.getElementById("classBrowser").style.width = wlw;'.
	html html:
			'document.getElementById("hiddenAndMonaco").style.height = th;
		}'.
	html html: '</script>'.
		html document addLoadScript: (JSStream on:
					 '  var modalNewPack = document.getElementById("idNewPackage");
  var modalRenamePack = document.getElementById("idRenamePackage");

// Get the button that opens the modal
var btnC = document.getElementById("btnClose");

// Get the <span> element that closes the modal
//var span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal
function openModalNewPack() {
document.getElementById("idNewPackage").style.display = "block";
	modalNewPack.style.display = "block";
}

modalNewPack.onclick = function() {
  document.getElementById("idNewPackage").style.display = "block";
}

// When the user clicks on <span> (x), close the modal
btnC.onclick = function() {
  modalNewPack.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modalNewPack) {
    //modalNewPack.style.display = "none";
document.getElementById("idNewPackage").style.display = "none";
  }
}')
]

{ #category : #rendering }
ASDPOClassBrowser >> renderContentPaneOn: html [

	html form
		class: 'definition';
		with: [ 
			html div
				id: 'hiddenAndMonaco';
				with: [ 
					html hiddenInput
						id: #hiddenContents;
						value: self contents;
						callback: [ :aString | self contents: aString ].
					self renderMonacoComponentOn: html.
					html break.
					html submitButton
						value: 'accept';
						callback: [ self accept ];
						onClick: (JSStream on:
										 'var monacoComp = document.getElementsByTagName(''textarea'');
					 $(''#hiddenContents'').val(monacoComp[0].value) 
')
					"	html submitButton on: #accept of: self"
					]
			].
	html document addLoadScript: (JSStream on:
					 'var monacoComp = document.getElementsByTagName(''textarea'');
					monacoComp[0].addEventListener(''change'', loadValue); 
					monacoComp[0].addEventListener(''load'', loadValue); 
					function loadValue(){ $(''#hiddenContents'').val(monacoComp[0].value) }
')
]

{ #category : #'rendering-class' }
ASDPOClassBrowser >> renderCopyClassName: html [

	| name |
	html form: [ 
			html mdlDialogTitle: 'Copy Class'.
			html mdlDialogContent: [ 
					html mdlTextFieldContainer
						floatingLabel;
						with: [ 
							html mdlTextFieldLabel
								for: html nextId;
								with: 'Name'.
							html mdlTextFieldInput
								id: html lastId;
								callback: [ :input | name := input ]
							]
					].
			html mdlDialogActions: [ 
					html mdlButton
						beSubmit;
						callback: [ 
							(RBCopyPackageRefactoring copyPackage:
										 self session selectedPackage name
									 in: name) execute
							];
						with: 'Accept'.
					html mdlButton
						id: self rootDialogCloseId;
						with: 'Cancel'
					]
			]
]

{ #category : #'rendering-package' }
ASDPOClassBrowser >> renderCopyPackageName: html [

	| name |
	html form: [ 
			html mdlDialogTitle: 'Rename Package'.
			html mdlDialogContent: [ 
					html mdlTextFieldContainer
						floatingLabel;
						with: [ 
							html mdlTextFieldLabel
								for: html nextId;
								with: 'Name'.
							html mdlTextFieldInput
								id: html lastId;
								callback: [ :input | name := input ]
							]
					].
			html mdlDialogActions: [ 
					html mdlButton
						beSubmit;
						callback: [ 
							(RBCopyPackageRefactoring 
		copyPackage: self session selectedPackage name 
		in: name) execute. 
							];
						with: 'Accept'.
					html mdlButton
						id: self rootDialogCloseId;
						with: 'Cancel'
					]
			]
]

{ #category : #'rendering-package' }
ASDPOClassBrowser >> renderCreateNewPackageName: html [

	| name |
	html form: [ 
			html mdlDialogTitle: 'Good job !'.
			html mdlDialogContent: [ 
					html mdlTextFieldContainer
						floatingLabel;
						with: [ 
							html mdlTextFieldLabel
								for: html nextId;
								with: 'Name'.
							html mdlTextFieldInput
								id: html lastId;
								callback: [ :input | name := input ]
							]
					].
			html mdlDialogActions: [ 
					html mdlButton
						beSubmit;
						callback: [ RPackageOrganizer default createPackageNamed: name ];
						with: 'Accept'.
					html mdlButton
						id: self rootDialogCloseId;
						with: 'Cancel'
					]
			]
]

{ #category : #rendering }
ASDPOClassBrowser >> renderMessageOn: html [
	message isNil
		ifFalse: [ html strong: message ]
]

{ #category : #rendering }
ASDPOClassBrowser >> renderModeButtonsOn: html [

	| idRenameP idCopyP idNewP |
	idNewP := 'idNewPackage'.
	idCopyP := 'idCopyPackage'.
	idRenameP := 'idRenamePackage'.

	html form
		class: 'modes';
		with: [ 
			html div
				style:
					'padding: 8px; display: -webkit-flex; display: -ms-flexbox; display: flex; -webkit-flex-flow: row wrap; -ms-flex-flow: row wrap; flex-flow: row wrap; flex-direction: row; flex-wrap: nowrap;';
				with: [ 
					html mdlButton
						style: 'margin-right: 10px;';
						callback: [ self showInstance ];
						raised;
						beSubmit;
						rippleEffect;
						with: 'instance'.
					html mdlButton
						style: 'margin-right: 10px;';
						raised;
						callback: [ self showHelp ];
						beSubmit;
						rippleEffect;
						with: 'help'.
					html mdlButton
						callback: [ self showClass ];
						style: 'margin-right: 10px;';
						raised;
						beSubmit;
						rippleEffect;
						with: 'class'.
					html mdlButton
						id: 'btnAccessors';
						style: 'margin-right: 10px;';
						callback: [ self addAccessor ];
						raised;
						beSubmit;
						rippleEffect;
						with: 'Accessors'.

					self session selectedPackage ifNotNil: [ 
							html mdlButton
								id: #bottomLeftButtonRefacturing;
								raised;
								with: 'Package Menu'.
							html mdlMenu
								bottomLeft;
								for: #bottomLeftButtonRefacturing;
								with: [ 
									html mdlMenuItem
										openDialogWithId: self rootDialogOpenId;
										onClickUpdateRootDialogWith: [ :r | 
											self renderCreateNewPackageName: r ];
										with: 'New'.
									html mdlMenuItem
										openDialogWithId: self rootDialogOpenId;
										onClickUpdateRootDialogWith: [ :r | 
											self renderRenamePackageName: r ];
										with: 'Rename'.
									html mdlMenuItem
										"onClick: self removePackage;"
										with: 'Remove'
									]
							].
					self session selectedClass ifNotNil: [ 
							html mdlButton
								id: #bottomLeftButtonClassRefacturing;
								raised;
								with: 'Class Menu'.
							html mdlMenu
								bottomLeft;
								for: #bottomLeftButtonClassRefacturing;
								with: [ 
									html mdlMenuItem with: 'New'.
									html mdlMenuItem
										onClick: 'openModalNewPack();';
										with: 'Rename'.
									html mdlMenuItem
										onClick: 'openModalNewPack();';
										with: 'Copy'
									]
							]
					].
			html document addLoadScript: (JSStream on:
							 '$("#bottomLeftButtonRefacturing").click(function(event){
    							event.preventDefault();});
							$("#bottomLeftButtonClassRefacturing").click(function(event){
    							event.preventDefault();});
							')
			]
]

{ #category : #rendering }
ASDPOClassBrowser >> renderMonacoComponentOn: html [
	html render: (MonacoComponent
				code: self contents
				language: MonacoLanguage smalltalk)
]

{ #category : #'rendering-package' }
ASDPOClassBrowser >> renderRenamePackageName: html [

	| name |
	html form: [ 
		
					html mdlDialogTitle: 'Rename Package'.
					html mdlDialogContent: [ 
								html mdlTextFieldContainer
									floatingLabel;
									with: [ 
										html mdlTextFieldLabel
											for: html nextId;
											with: 'Name'.
										html mdlTextFieldInput
											id: html lastId;
											callback: [ :input | name := input ]
										]
								].
					html mdlDialogActions: [ 
							html mdlButton
								beSubmit;
								callback: [ 
									RBRenamePackageRefactoring rename:
												(self session selectedPackage name to: name) execute
									];
								with: 'Accept'.
							html mdlButton
								id: 'idButtonCloseRename';
								with: 'Cancel'
							]
					]
		
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
	background-color: rgb(13, 17, 23) !important;
    color: rgb(201, 209, 217) !important;
    border-width: 1px !important;
    border-style: solid !important;
    border-color: rgb(52, 52, 52) !important;
    border-image: initial !important;: 1px solid #aaa;
}


}

form.mode {
	clear: both;
}

form.definition textarea {
	width: 100%;
	height: 200px;
	border: 1px solid #aaa;
}
.monaco-demo{
	display: flex;
	display: -webkit-flex;
	display: -ms-flexbox;
	background-color: rgb(13, 17, 23) !important;
    color: rgb(201, 209, 217) !important;
    border-width: 1px !important;
    border-style: solid !important;
    border-color: rgb(52, 52, 52) !important;
    border-image: initial !important;: 1px solid #aaa;
	height: 100%;
	width: 100%;
}

.modal {
 
  position: fixed; /* Stay in place */
  z-index: 1000; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
background-color: rgb(13, 17, 23) !important;
 border-color: rgb(52, 52, 52) !important;
    border-radius: 6px;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
    animation-name: SelectMenu-modal-animation--sm;
}

/* Modal Content */
.modal-content {
  background-color: rgb(13, 17, 23) !important;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
}

/* The Close Button */
.close {
  color: #aaaaaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}
'
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

	"protocol: updating"

	super updateRoot: anHtmlRoot.
	anHtmlRoot link
		beStylesheet;
		url: 'https://fonts.googleapis.com/css?family=Roboto'.
	anHtmlRoot javascript url:
			'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.15.6/min/vs/loader.js'.
	anHtmlRoot title: 'Pharo Ide - ' , self class version
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
