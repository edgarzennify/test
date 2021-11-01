webpackJsonp([0,1],{76:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var o=n(0),s=(n.n(o),n(11)),i=n(5),a=this&&this.__extends||function(){var e=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(e,t){e.__proto__=t}||function(e,t){for(var n in t)t.hasOwnProperty(n)&&(e[n]=t[n])};return function(t,n){function o(){this.constructor=t}e(t,n),t.prototype=null===n?Object.create(n):(o.prototype=n.prototype,new o)}}(),r=function(e){function t(){var t=e.call(this)||this;return t.state={SaveAndContinue:!1},t.onSaveAndContinue=t.onSaveAndContinue.bind(t),t}return a(t,e),t.prototype.onSaveAndContinue=function(){this.setState({SaveAndContinue:!0}),this.props.onSaveAndContinue()},t.prototype.componentWillReceiveProps=function(e){e.show||this.setState({SaveAndContinue:!1})},t.prototype.render=function(){return o.createElement(s.a,{show:this.props.show},o.createElement(s.a.Header,null,o.createElement("div",{className:"description"},"Leaving?")),o.createElement(s.a.Body,null,"Unsaved changes have been made."),o.createElement(s.a.Footer,null,o.createElement(i.a,{onClick:this.onSaveAndContinue,loading:this.state.SaveAndContinue,className:"btn"},"Save and Continue"),null==this.props.showWithoutSavingButton||this.props.showWithoutSavingButton?o.createElement(i.a,{onClick:this.props.onContinueWithoutSaving,disabled:this.state.SaveAndContinue,className:"btn"},"Discard and Continue"):null,o.createElement(i.a,{onClick:this.props.onCancel,disabled:this.state.SaveAndContinue,className:"btn"},"Return")))},t}(o.Component);t.default=r},79:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var o=n(0),s=(n.n(o),n(11)),i=n(12),a=n(5),r=n(2),c=n(76),u=n(13),l=n(6),h=this&&this.__extends||function(){var e=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(e,t){e.__proto__=t}||function(e,t){for(var n in t)t.hasOwnProperty(n)&&(e[n]=t[n])};return function(t,n){function o(){this.constructor=t}e(t,n),t.prototype=null===n?Object.create(n):(o.prototype=n.prototype,new o)}}(),d=this&&this.__awaiter||function(e,t,n,o){return new(n||(n=Promise))(function(s,i){function a(e){try{c(o.next(e))}catch(e){i(e)}}function r(e){try{c(o.throw(e))}catch(e){i(e)}}function c(e){e.done?s(e.value):new n(function(t){t(e.value)}).then(a,r)}c((o=o.apply(e,t||[])).next())})},p=this&&this.__generator||function(e,t){function n(e){return function(t){return o([e,t])}}function o(n){if(s)throw new TypeError("Generator is already executing.");for(;c;)try{if(s=1,i&&(a=i[2&n[0]?"return":n[0]?"throw":"next"])&&!(a=a.call(i,n[1])).done)return a;switch(i=0,a&&(n=[0,a.value]),n[0]){case 0:case 1:a=n;break;case 4:return c.label++,{value:n[1],done:!1};case 5:c.label++,i=n[1],n=[0];continue;case 7:n=c.ops.pop(),c.trys.pop();continue;default:if(a=c.trys,!(a=a.length>0&&a[a.length-1])&&(6===n[0]||2===n[0])){c=0;continue}if(3===n[0]&&(!a||n[1]>a[0]&&n[1]<a[3])){c.label=n[1];break}if(6===n[0]&&c.label<a[1]){c.label=a[1],a=n;break}if(a&&c.label<a[2]){c.label=a[2],c.ops.push(n);break}a[2]&&c.ops.pop(),c.trys.pop();continue}n=t.call(e,c)}catch(e){n=[6,e],i=0}finally{s=a=0}if(5&n[0])throw n[1];return{value:n[0]?n[1]:void 0,done:!0}}var s,i,a,r,c={label:0,sent:function(){if(1&a[0])throw a[1];return a[1]},trys:[],ops:[]};return r={next:n(0),throw:n(1),return:n(2)},"function"==typeof Symbol&&(r[Symbol.iterator]=function(){return this}),r},f=function(e){function t(){var t=e.call(this)||this;return t._tmRepository=new u.a,t.state={show:!1,chosen:"",isAdding:!1,showLeavePage:!1},t.onAddNew=t.onAddNew.bind(t),t.onChangeItem=t.onChangeItem.bind(t),t.onAddNewFinish=t.onAddNewFinish.bind(t),t._addNewExclusions=[],t._addNewExclusions.push("Lockbox"),t._addNewExclusions.push("Loan, Loan/Investment Sweep"),t._addNewExclusions.push("ZBA"),t._addNewExclusions.push("Enterprise Automated Payables"),t}return h(t,e),t.prototype.componentDidMount=function(){this.setState({chosen:""})},t.prototype.componentWillReceiveProps=function(e){e.show&&!this.state.isAdding&&this.setState({chosen:""}),this.setState({show:e.show})},t.prototype.onAddNew=function(){return d(this,void 0,void 0,function(){return p(this,function(e){switch(e.label){case 0:return this.state.chosen.length>0?[4,n.i(l.a)(this,{isAdding:!0})]:[3,5];case 1:return e.sent(),this.props.isDirty?[4,n.i(l.a)(this,{showLeavePage:!0})]:[3,3];case 2:return e.sent(),[3,5];case 3:return[4,this.onAddNewFinish()];case 4:e.sent(),e.label=5;case 5:return[2]}})})},t.prototype.onAddNewFinish=function(){return d(this,void 0,void 0,function(){var e,t;return p(this,function(o){switch(o.label){case 0:return[4,this.props.callback()];case 1:return(e=o.sent())?(recordJson.RecordTypeId=this.state.chosen,recordJson.Id=null,recordJson.TM_Service_Request_Packet__c=this.props.packet.PacketDetail.Id,[4,this._tmRepository.bootstrapEntity()]):[3,8];case 2:return t=o.sent(),null===t?[3,4]:[4,n.i(l.a)(this,{showLeavePage:!1})];case 3:return o.sent(),location.href=location.origin+"/"+t.Packet.Request.Id+"/e",[3,6];case 4:return[4,n.i(l.a)(this,{showLeavePage:!1})];case 5:o.sent(),o.label=6;case 6:return[4,n.i(l.a)(this,{isAdding:!1})];case 7:o.sent(),o.label=8;case 8:return[2]}})})},t.prototype.onChangeItem=function(e){return d(this,void 0,void 0,function(){return p(this,function(t){switch(t.label){case 0:return[4,n.i(l.a)(this,{chosen:e.target.value})];case 1:return t.sent(),[2]}})})},t.prototype.renderOptions=function(){var e=this;if(void 0===this.props.packet.AllProducts)return[];var t=[];return t.push({Label:"--Choose a Product--",Value:""}),this.props.packet.AllProducts.forEach(function(n){if(e._addNewExclusions.findIndex(function(e){return e===n.Name})>-1||0===e.props.packet.Requests.filter(function(e){return e.Name===n.Name}).length){var o={Value:n.Id,Label:n.Name};t.push(o)}}),t},t.prototype.render=function(){var e=this;return o.createElement("div",null,o.createElement(s.a,{show:this.state.show},o.createElement(s.a.Header,null,o.createElement("div",{className:"pageDescription"},"Add Product")),o.createElement(s.a.Body,null,o.createElement(i.a,{label:"Product",name:"AddNew",onChange:this.onChangeItem,options:this.renderOptions(),selected:this.state.chosen,required:r.a.NotRequired})),o.createElement(s.a.Footer,null,o.createElement(a.a,{className:"btn",onClick:this.onAddNew,loading:this.state.isAdding},"Add Product"),o.createElement(a.a,{className:"btn",onClick:this.props.onClose,loading:this.state.isAdding},"Close"))),o.createElement(c.default,{show:this.state.showLeavePage,onCancel:function(){e.setState({showLeavePage:!1})},onContinueWithoutSaving:null,onSaveAndContinue:this.onAddNewFinish,showWithoutSavingButton:!1}))},t}(o.Component);t.default=f}});