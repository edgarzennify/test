webpackJsonp([3],{77:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i=n(0),a=(n.n(i),n(11)),o=n(24),s=n(8),r=n(5),l=n(14),c=n(6),u=this&&this.__extends||function(){var t=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var n in e)e.hasOwnProperty(n)&&(t[n]=e[n])};return function(e,n){function i(){this.constructor=e}t(e,n),e.prototype=null===n?Object.create(n):(i.prototype=n.prototype,new i)}}(),p=this&&this.__awaiter||function(t,e,n,i){return new(n||(n=Promise))(function(a,o){function s(t){try{l(i.next(t))}catch(t){o(t)}}function r(t){try{l(i.throw(t))}catch(t){o(t)}}function l(t){t.done?a(t.value):new n(function(e){e(t.value)}).then(s,r)}l((i=i.apply(t,e||[])).next())})},h=this&&this.__generator||function(t,e){function n(t){return function(e){return i([t,e])}}function i(n){if(a)throw new TypeError("Generator is already executing.");for(;l;)try{if(a=1,o&&(s=o[2&n[0]?"return":n[0]?"throw":"next"])&&!(s=s.call(o,n[1])).done)return s;switch(o=0,s&&(n=[0,s.value]),n[0]){case 0:case 1:s=n;break;case 4:return l.label++,{value:n[1],done:!1};case 5:l.label++,o=n[1],n=[0];continue;case 7:n=l.ops.pop(),l.trys.pop();continue;default:if(s=l.trys,!(s=s.length>0&&s[s.length-1])&&(6===n[0]||2===n[0])){l=0;continue}if(3===n[0]&&(!s||n[1]>s[0]&&n[1]<s[3])){l.label=n[1];break}if(6===n[0]&&l.label<s[1]){l.label=s[1],s=n;break}if(s&&l.label<s[2]){l.label=s[2],l.ops.push(n);break}s[2]&&l.ops.pop(),l.trys.pop();continue}n=e.call(t,l)}catch(t){n=[6,t],o=0}finally{a=s=0}if(5&n[0])throw n[1];return{value:n[0]?n[1]:void 0,done:!0}}var a,o,s,r,l={label:0,sent:function(){if(1&s[0])throw s[1];return s[1]},trys:[],ops:[]};return r={next:n(0),throw:n(1),return:n(2)},"function"==typeof Symbol&&(r[Symbol.iterator]=function(){return this}),r},d=function(t){function e(){var e=t.call(this)||this;return e.state={saving:!1,closeDisabled:!1,parentDetails:void 0,childDetails:void 0},e.onSaving=e.onSaving.bind(e),e}return u(e,t),e.prototype.componentDidMount=function(){this.setState({parentDetails:this.props.parentDetails,childDetails:this.props.childDetails,saving:!1,closeDisabled:!1})},e.prototype.componentWillReceiveProps=function(t){t.isOpen?this.setState({parentDetails:t.parentDetails,childDetails:t.childDetails,closeDisabled:t.closeDisabled}):this.setState({saving:!1,closeDisabled:!1,parentDetails:void 0,childDetails:void 0})},e.prototype.onSaving=function(){return p(this,void 0,void 0,function(){var t;return h(this,function(e){switch(e.label){case 0:return[4,n.i(c.a)(this,{saving:!0})];case 1:return e.sent(),[4,this.props.onSave()];case 2:return t=e.sent(),t?[3,4]:[4,n.i(c.a)(this,{saving:!1})];case 3:e.sent(),e.label=4;case 4:return[2]}})})},e.prototype.render=function(){return i.createElement(a.a,{show:this.props.isOpen},i.createElement(a.a.Header,null,i.createElement("div",{className:"type"},this.props.description),i.createElement("div",{className:"description"},this.props.title)),i.createElement(a.a.Body,null,i.createElement(l.a,{errors:this.props.errors}),i.createElement(o.a,{onClick:function(){},type:s.a.Edit,data:this.state.parentDetails}),void 0!=this.props.childTitle&&void 0!=this.state.childDetails&&0!==this.state.childDetails.EditMetadata.Sections.length?i.createElement(s.b,{onChange:this.props.onModalChange,data:this.state.childDetails,title:this.props.childTitle,type:s.a.Edit,onAdd:function(){return null},onEdit:function(){return null},onSelect:function(){return null},showEdit:!1,handleSelectAll:function(){},loadingId:""}):null),i.createElement(a.a.Footer,null,i.createElement(r.a,{className:"btn",onClick:this.onSaving,disabled:this.state.saving,loading:this.state.saving},"Save"),i.createElement(r.a,{className:"btn",disabled:this.state.saving&&this.state.closeDisabled,onClick:this.props.onCancel},"Close")))},e}(i.Component);e.default=d}});