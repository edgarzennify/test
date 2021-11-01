webpackJsonp([4],{

/***/ 88:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_react__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_react___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_react__);

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

var LoadState;
(function (LoadState) {
    LoadState[LoadState["Saving"] = 0] = "Saving";
    LoadState[LoadState["Validating"] = 1] = "Validating";
    LoadState[LoadState["Timeout"] = 2] = "Timeout";
})(LoadState || (LoadState = {}));
var SaveLoader = (function (_super) {
    __extends(SaveLoader, _super);
    function SaveLoader() {
        var _this = _super.call(this) || this;
        _this._timer = -1;
        _this._timeElasped = 0;
        _this.state = {
            LoadStatus: LoadState.Saving
        };
        _this.getMessage = _this.getMessage.bind(_this);
        _this.setLoadState = _this.setLoadState.bind(_this);
        _this.getDots = _this.getDots.bind(_this);
        return _this;
    }
    SaveLoader.prototype.componentDidMount = function () {
        var _this = this;
        this._timer = setInterval(function () {
            _this.setLoadState();
        }, 500);
    };
    SaveLoader.prototype.componentWillUnmount = function () {
        clearInterval(this._timer);
    };
    SaveLoader.prototype.setLoadState = function () {
        this._timeElasped++;
        switch (this._timeElasped) {
            case 20:
                this.setState({ LoadStatus: LoadState.Validating });
                break;
            case 60:
                this.setState({ LoadStatus: LoadState.Timeout });
                clearInterval(this._timer);
                break;
            default:
                this.forceUpdate();
        }
    };
    SaveLoader.prototype.getMessage = function () {
        switch (this.state.LoadStatus) {
            case LoadState.Saving:
                return (__WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("div", null,
                    "Saving ",
                    this.getDots()));
            case LoadState.Validating:
                return (__WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("div", null,
                    "Validating ",
                    this.getDots()));
            case LoadState.Timeout:
                return (__WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("div", null,
                    "Timeout occured",
                    __WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("button", { className: "save-loader-button", onClick: this.props.onSaveLoaderClose }, "Close")));
            default:
                return null;
        }
    };
    SaveLoader.prototype.getDots = function () {
        switch (this._timeElasped % 3) {
            case 0: return ".";
            case 1: return "..";
            case 2: return "...";
        }
    };
    SaveLoader.prototype.render = function () {
        return (__WEBPACK_IMPORTED_MODULE_0_react__["createElement"]("div", { className: "save-loader" }, this.getMessage()));
    };
    return SaveLoader;
}(__WEBPACK_IMPORTED_MODULE_0_react__["Component"]));
/* harmony default export */ __webpack_exports__["default"] = (SaveLoader);


/***/ })

});
//# sourceMappingURL=4.js.map