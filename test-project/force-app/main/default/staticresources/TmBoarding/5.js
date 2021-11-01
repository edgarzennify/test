webpackJsonp([5],{

/***/ 87:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_react__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_react___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_react__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__common_Modal__ = __webpack_require__(37);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__Details__ = __webpack_require__(48);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__Grid__ = __webpack_require__(6);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__common_Button__ = __webpack_require__(8);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__common_Errors__ = __webpack_require__(41);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__lib_Helpers__ = __webpack_require__(35);

var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = y[op[0] & 2 ? "return" : op[0] ? "throw" : "next"]) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [0, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};







var EditModal = (function (_super) {
    __extends(EditModal, _super);
    function EditModal() {
        var _this = _super.call(this) || this;
        _this.state = {
            saving: false,
            closeDisabled: false,
            parentDetails: undefined,
            childDetails: undefined
        };
        _this.onSaving = _this.onSaving.bind(_this);
        return _this;
    }
    EditModal.prototype.componentDidMount = function () {
        this.setState({ parentDetails: this.props.parentDetails, childDetails: this.props.childDetails, saving: false, closeDisabled: false });
    };
    EditModal.prototype.componentWillReceiveProps = function (nextProps) {
        if (!nextProps.isOpen) {
            this.setState({ saving: false, closeDisabled: false, parentDetails: undefined, childDetails: undefined });
        }
        else {
            this.setState({ parentDetails: nextProps.parentDetails, childDetails: nextProps.childDetails, closeDisabled: nextProps.closeDisabled });
        }
    };
    EditModal.prototype.onSaving = function () {
        return __awaiter(this, void 0, void 0, function () {
            var didSave;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_6__lib_Helpers__["a" /* setStateAsync */])(this, { saving: true })];
                    case 1:
                        _a.sent();
                        return [4 /*yield*/, this.props.onSave()];
                    case 2:
                        didSave = _a.sent();
                        if (!!didSave) return [3 /*break*/, 4];
                        return [4 /*yield*/, __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_6__lib_Helpers__["a" /* setStateAsync */])(this, { saving: false })];
                    case 3:
                        _a.sent();
                        _a.label = 4;
                    case 4: return [2 /*return*/];
                }
            });
        });
    };
    EditModal.prototype.render = function () {
        return (__WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_1__common_Modal__["a" /* default */], { show: this.props.isOpen },
            __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_1__common_Modal__["a" /* default */].Header, null,
                __WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("div", { className: "type" }, this.props.description),
                __WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("div", { className: "description" }, this.props.title)),
            __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_1__common_Modal__["a" /* default */].Body, null,
                __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_5__common_Errors__["a" /* default */], { errors: this.props.errors }),
                __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_2__Details__["a" /* default */], { onClick: function () { }, type: __WEBPACK_IMPORTED_MODULE_3__Grid__["a" /* Type */].Edit, data: this.state.parentDetails }),
                this.props.childTitle != undefined && this.state.childDetails != undefined && this.state.childDetails.EditMetadata.Sections.length !== 0 ?
                    __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_3__Grid__["b" /* default */], { onChange: this.props.onModalChange, data: this.state.childDetails, title: this.props.childTitle, type: __WEBPACK_IMPORTED_MODULE_3__Grid__["a" /* Type */].Edit, onAdd: function () { return null; }, onEdit: function () { return null; }, onSelect: function () { return null; }, showEdit: false, handleSelectAll: function () { }, loadingId: "" })
                    : null),
            __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_1__common_Modal__["a" /* default */].Footer, null,
                __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_4__common_Button__["a" /* default */], { className: "btn", onClick: this.onSaving, disabled: this.state.saving, loading: this.state.saving }, "Save"),
                __WEBPACK_IMPORTED_MODULE_0_react__["createElement"](__WEBPACK_IMPORTED_MODULE_4__common_Button__["a" /* default */], { className: "btn", disabled: this.state.saving && this.state.closeDisabled, onClick: this.props.onCancel }, "Close"))));
    };
    return EditModal;
}(__WEBPACK_IMPORTED_MODULE_0_react__["Component"]));
/* harmony default export */ __webpack_exports__["default"] = (EditModal);


/***/ })

});
//# sourceMappingURL=5.js.map