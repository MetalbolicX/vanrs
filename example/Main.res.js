//#region node_modules/.pnpm/rescript@11.1.4/node_modules/rescript/lib/es6/caml_obj.js
var obj_dup = function(x) {
	if (Array.isArray(x)) {
		var len = x.length;
		var v = new Array(len);
		for (var i = 0; i < len; ++i) v[i] = x[i];
		if (x.TAG !== void 0) v.TAG = x.TAG;
		return v;
	}
	return Object.assign({}, x);
};

//#endregion
//#region node_modules/.pnpm/rescript@11.1.4/node_modules/rescript/lib/es6/caml_option.js
function some(x) {
	if (x === void 0) return { BS_PRIVATE_NESTED_SOME_NONE: 0 };
	else if (x !== null && x.BS_PRIVATE_NESTED_SOME_NONE !== void 0) return { BS_PRIVATE_NESTED_SOME_NONE: x.BS_PRIVATE_NESTED_SOME_NONE + 1 | 0 };
	else return x;
}
function valFromOption(x) {
	if (!(x !== null && x.BS_PRIVATE_NESTED_SOME_NONE !== void 0)) return x;
	var depth = x.BS_PRIVATE_NESTED_SOME_NONE;
	if (depth === 0) return;
	else return { BS_PRIVATE_NESTED_SOME_NONE: depth - 1 | 0 };
}

//#endregion
//#region node_modules/.pnpm/rescript@11.1.4/node_modules/rescript/lib/es6/belt_Array.js
function concatMany(arrs) {
	var lenArrs = arrs.length;
	var totalLen = 0;
	for (var i = 0; i < lenArrs; ++i) totalLen = totalLen + arrs[i].length | 0;
	var result = new Array(totalLen);
	totalLen = 0;
	for (var j = 0; j < lenArrs; ++j) {
		var cur = arrs[j];
		for (var k = 0, k_finish = cur.length; k < k_finish; ++k) {
			result[totalLen] = cur[k];
			totalLen = totalLen + 1 | 0;
		}
	}
	return result;
}

//#endregion
//#region node_modules/.pnpm/vanjs-core@1.5.5/node_modules/vanjs-core/src/van.js
let protoOf = Object.getPrototypeOf;
let changedStates, derivedStates, curDeps, curNewDerives, alwaysConnectedDom = { isConnected: 1 };
let gcCycleInMs = 1e3, statesToGc, propSetterCache = {};
let objProto = protoOf(alwaysConnectedDom), funcProto = protoOf(protoOf), _undefined;
let addAndScheduleOnFirst = (set, s, f, waitMs) => (set ?? (setTimeout(f, waitMs), /* @__PURE__ */ new Set())).add(s);
let runAndCaptureDeps = (f, deps, arg) => {
	let prevDeps = curDeps;
	curDeps = deps;
	try {
		return f(arg);
	} catch (e) {
		console.error(e);
		return arg;
	} finally {
		curDeps = prevDeps;
	}
};
let keepConnected = (l) => l.filter((b) => b._dom?.isConnected);
let addStatesToGc = (d) => statesToGc = addAndScheduleOnFirst(statesToGc, d, () => {
	for (let s of statesToGc) s._bindings = keepConnected(s._bindings), s._listeners = keepConnected(s._listeners);
	statesToGc = _undefined;
}, gcCycleInMs);
let stateProto = {
	get val() {
		curDeps?._getters?.add(this);
		return this.rawVal;
	},
	get oldVal() {
		curDeps?._getters?.add(this);
		return this._oldVal;
	},
	set val(v) {
		curDeps?._setters?.add(this);
		if (v !== this.rawVal) {
			this.rawVal = v;
			this._bindings.length + this._listeners.length ? (derivedStates?.add(this), changedStates = addAndScheduleOnFirst(changedStates, this, updateDoms)) : this._oldVal = v;
		}
	}
};
let state$1 = (initVal) => ({
	__proto__: stateProto,
	rawVal: initVal,
	_oldVal: initVal,
	_bindings: [],
	_listeners: []
});
let bind = (f, dom) => {
	let deps = {
		_getters: /* @__PURE__ */ new Set(),
		_setters: /* @__PURE__ */ new Set()
	}, binding = { f }, prevNewDerives = curNewDerives;
	curNewDerives = [];
	let newDom = runAndCaptureDeps(f, deps, dom);
	newDom = (newDom ?? document).nodeType ? newDom : new Text(newDom);
	for (let d of deps._getters) deps._setters.has(d) || (addStatesToGc(d), d._bindings.push(binding));
	for (let l of curNewDerives) l._dom = newDom;
	curNewDerives = prevNewDerives;
	return binding._dom = newDom;
};
let derive$1 = (f, s = state$1(), dom) => {
	let deps = {
		_getters: /* @__PURE__ */ new Set(),
		_setters: /* @__PURE__ */ new Set()
	}, listener = {
		f,
		s
	};
	listener._dom = dom ?? curNewDerives?.push(listener) ?? alwaysConnectedDom;
	s.val = runAndCaptureDeps(f, deps, s.rawVal);
	for (let d of deps._getters) deps._setters.has(d) || (addStatesToGc(d), d._listeners.push(listener));
	return s;
};
let add$1 = (dom, ...children) => {
	for (let c of children.flat(Infinity)) {
		let protoOfC = protoOf(c ?? 0);
		let child = protoOfC === stateProto ? bind(() => c.val) : protoOfC === funcProto ? bind(c) : c;
		child != _undefined && dom.append(child);
	}
	return dom;
};
let tag = (ns, name, ...args) => {
	let [{ is,...props }, ...children] = protoOf(args[0] ?? 0) === objProto ? args : [{}, ...args];
	let dom = ns ? document.createElementNS(ns, name, { is }) : document.createElement(name, { is });
	for (let [k, v] of Object.entries(props)) {
		let getPropDescriptor = (proto) => proto ? Object.getOwnPropertyDescriptor(proto, k) ?? getPropDescriptor(protoOf(proto)) : _undefined;
		let cacheKey = name + "," + k;
		let propSetter = propSetterCache[cacheKey] ??= getPropDescriptor(protoOf(dom))?.set ?? 0;
		let setter = k.startsWith("on") ? (v$1, oldV) => {
			let event = k.slice(2);
			dom.removeEventListener(event, oldV);
			dom.addEventListener(event, v$1);
		} : propSetter ? propSetter.bind(dom) : dom.setAttribute.bind(dom, k);
		let protoOfV = protoOf(v ?? 0);
		k.startsWith("on") || protoOfV === funcProto && (v = derive$1(v), protoOfV = stateProto);
		protoOfV === stateProto ? bind(() => (setter(v.val, v._oldVal), dom)) : setter(v);
	}
	return add$1(dom, children);
};
let handler = (ns) => ({ get: (_, name) => tag.bind(_undefined, ns, name) });
let update = (dom, newDom) => newDom ? newDom !== dom && dom.replaceWith(newDom) : dom.remove();
let updateDoms = () => {
	let iter = 0, derivedStatesArray = [...changedStates].filter((s) => s.rawVal !== s._oldVal);
	do {
		derivedStates = /* @__PURE__ */ new Set();
		for (let l of new Set(derivedStatesArray.flatMap((s) => s._listeners = keepConnected(s._listeners)))) derive$1(l.f, l.s, l._dom), l._dom = _undefined;
	} while (++iter < 100 && (derivedStatesArray = [...derivedStates]).length);
	let changedStatesArray = [...changedStates].filter((s) => s.rawVal !== s._oldVal);
	changedStates = _undefined;
	for (let b of new Set(changedStatesArray.flatMap((s) => s._bindings = keepConnected(s._bindings)))) update(b._dom, bind(b.f, b._dom)), b._dom = _undefined;
	for (let s of changedStatesArray) s._oldVal = s.rawVal;
};
var van_default = {
	tags: new Proxy((ns) => new Proxy(tag, handler(ns)), handler()),
	hydrate: (dom, f) => update(dom, bind(f, dom)),
	add: add$1,
	state: state$1,
	derive: derive$1
};

//#endregion
//#region node_modules/.pnpm/@rescript+core@1.6.1_rescript@11.1.4/node_modules/@rescript/core/src/Core__Array.res.mjs
function reduce(arr, init, f) {
	return arr.reduce(f, init);
}

//#endregion
//#region node_modules/.pnpm/rescript@11.1.4/node_modules/rescript/lib/es6/caml_splice_call.js
var spliceApply = function(fn, args) {
	var i, argLen;
	argLen = args.length;
	var applied = [];
	for (i = 0; i < argLen - 1; ++i) applied.push(args[i]);
	var lastOne = args[argLen - 1];
	for (i = 0; i < lastOne.length; ++i) applied.push(lastOne[i]);
	return fn.apply(null, applied);
};

//#endregion
//#region src/Van.res.mjs
function castChild(child) {
	switch (child.TAG) {
		case "Text": return {
			NAME: "Text",
			VAL: child._0
		};
		case "Number": return {
			NAME: "Number",
			VAL: child._0
		};
		case "Int": return {
			NAME: "Int",
			VAL: child._0
		};
		case "Dom": return {
			NAME: "Dom",
			VAL: child._0
		};
		case "Boolean": return {
			NAME: "Boolean",
			VAL: child._0
		};
		case "State": return {
			NAME: "State",
			VAL: child._0
		};
		case "Nil": return {
			NAME: "Nil",
			VAL: child._0
		};
	}
}
function add(parent, children) {
	var parsedChildren = children.map(function(c) {
		return castChild(c);
	}).map(function(c) {
		return c.VAL;
	});
	return spliceApply(van_default.add, [parent, parsedChildren]);
}
function resolveNamespace(namespace) {
	if (typeof namespace === "object") return namespace._0;
	switch (namespace) {
		case "Html": return;
		case "Svg": return "http://www.w3.org/2000/svg";
		case "MathMl": return "http://www.w3.org/1998/Math/MathML";
	}
}
function make(tag$1, namespaceOpt) {
	var namespace = namespaceOpt !== void 0 ? namespaceOpt : "Html";
	return {
		tag: tag$1,
		namespace
	};
}
function attr(builder, attrs) {
	var newrecord = obj_dup(builder);
	newrecord.attrs = some(attrs);
	return newrecord;
}
function append(builder, child) {
	var newrecord = obj_dup(builder);
	var children = builder.children;
	newrecord.children = children !== void 0 ? concatMany([children, [child]]) : [child];
	return newrecord;
}
function appendChildren(builder, children) {
	return reduce(children, builder, function(list, child) {
		return append(list, child);
	});
}
function build(builder) {
	var attrs = builder.attrs;
	var children = builder.children;
	var nsOpt = builder.namespace;
	var tagName = builder.tag;
	var attrsOpt = some(attrs !== void 0 ? valFromOption(attrs) : {});
	var childrenOpt = children !== void 0 ? concatMany([children]) : [];
	var ns = nsOpt !== void 0 ? nsOpt : "Html";
	var attrs$1 = attrsOpt !== void 0 ? valFromOption(attrsOpt) : {};
	var children$1 = childrenOpt !== void 0 ? childrenOpt : [];
	var n = resolveNamespace(ns);
	var namespaceProxy = n !== void 0 ? van_default.tags(n) : van_default.tags();
	return ((proxy, tagName$1, attrs$2, children$2) => proxy[tagName$1](attrs$2, ...children$2))(namespaceProxy, tagName, attrs$1, children$1.map(function(c) {
		return castChild(c);
	}).map(function(c) {
		return c.VAL;
	}));
}
function state(prim) {
	return van_default.state(prim);
}
function derive(prim) {
	return van_default.derive(prim);
}
var Tags = {
	make,
	attr,
	append,
	appendChildren,
	build
};

//#endregion
//#region node_modules/.pnpm/rescript@11.1.4/node_modules/rescript/lib/es6/js_exn.js
function raiseError(str) {
	throw new Error(str);
}

//#endregion
//#region example/Main.res.mjs
var el = document.getElementById("root");
var root = el == null ? raiseError("Root element not found") : el;
function deriveState() {
	var initText = state("VanJs");
	var textLength = derive(function() {
		return initText.val.length;
	});
	return Tags.build(Tags.appendChildren(Tags.make("div", void 0), [
		{
			TAG: "Text",
			_0: "The length of the text is: "
		},
		{
			TAG: "Dom",
			_0: Tags.build(Tags.attr(Tags.make("input", void 0), {
				type: "text",
				value: initText.val,
				oninput: function($$event) {
					initText.val = $$event.target.value;
				}
			}))
		},
		{
			TAG: "State",
			_0: textLength
		}
	]));
}
add(root, [{
	TAG: "Dom",
	_0: deriveState()
}]);

//#endregion
export { deriveState, root };