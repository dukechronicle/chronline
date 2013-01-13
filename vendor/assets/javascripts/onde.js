; // Don't remove this lonely semi-colon

/* NOTES:
 * 
 * - Don't forget to escape.
 *   Use jQuery.fn.text and jQuery.fn.attr rather than string concatenation where possible.
 */


/*FIXME: Monkey-patching is not recommended */

// Monkey-patch for browser with no Array.indexOf support
if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(searchElement/*, fromIndex */) {
        "use strict";
        if (this === void 0 || this === null)
            throw new TypeError();
        var t = Object(this);
        var len = t.length >>> 0;
        if (len === 0)
            return -1;
        var n = 0;
        if (arguments.length > 0) {
            n = Number(arguments[1]);
            if (n !== n)
                n = 0;
            else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0))
                n = (n > 0 || -1) * Math.floor(Math.abs(n));
        }
        if (n >= len)
            return -1;
        var k = n >= 0 ? n : Math.max(len - Math.abs(n), 0);
        for (; k < len; k++) {
            if (k in t && t[k] === searchElement)
                return k;
        }
        return -1;
    };
}
// These two are nice things which JS misses so much
if (!String.prototype.startsWith) {
    String.prototype.startsWith = function (prefix) {
        "use strict";
        return this.lastIndexOf(prefix, 0) === 0;
    };
}
if (!String.prototype.endsWith) {
    String.prototype.endsWith = function (suffix) {
        "use strict";
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
}


var onde = (function () {
    return {
        simpleTypes: []
    };
})();

onde.PRIMITIVE_TYPES = ['string', 'number', 'integer', 'boolean', 'array', 'object', 'null'];
//onde.simpleTypes = ['string', 'number', 'integer', 'boolean', 'object', 'array', 'null', 'any'];

onde.Onde = function (formElement, schema, documentInst, opts) {
    var _inst = this;
    //this.options = opts;
    this.externalSchemas = {}; // A hash of cached external schemas. The key is the full URL of the schema.
    this.internalSchemas = {}; // List of schema for sub-objects
    this.fieldNamespaceSeparator = '.';
    this.fieldNamespaceSeparatorRegex = /\./g;
    this.formElement = $(formElement);
    this.panelElement = this.formElement.find('.onde-panel');
    this.documentSchema = schema;
    this.documentInstance = documentInst;
    // Object property adder
    this.panelElement.find('.property-add').live('click', function (evt) {
        evt.preventDefault();
        _inst.onAddObjectProperty($(this));
    });
    // Array item adder
    this.panelElement.find('.item-add').live('click', function (evt) {
        evt.preventDefault();
        _inst.onAddListItem($(this));
    });
    // Collapsible field (object and array)
    this.panelElement.find('.collapser').live('click', function (evt) {
        var collapser = $(this);
        var fieldId = collapser.attr('data-fieldvalue-container-id');
        //TODO: Check the field. It must not be inline.
        if (fieldId) {
            // Check the state first (for smoother animations)
            if (collapser.hasClass('collapsed')) {
                collapser.removeClass('collapsed');
                $('#' + fieldId).slideDown('fast');
            } else {
                //TODO: Display indicator (and/or summary) when collapsed
                $('#' + fieldId).slideUp('fast', function () {
                    collapser.addClass('collapsed');
                });
            }
        }
    });
    // Field deleter (property and item)
    this.panelElement.find('.field-delete').live('click', function (evt) {
        evt.preventDefault();
        evt.stopPropagation(); //CHECK: Only if collapsible
        $('#' + $(this).attr('data-id')).fadeOut('fast', function () {
            // Change the item's and siblings' classes accordingly
            //FIXME: This is unstable
            if ($(this).hasClass('first')) {
                $(this).next('li.field').addClass('first');
            }
            if ($(this).hasClass('last')) {
                $(this).prev('li.field').addClass('last');
            }
            $(this).remove();
        });
    });
    // Type selector
    this.panelElement.find('.field-type-select').live('change', function (evt) {
        evt.preventDefault();
        _inst.onFieldTypeChanged($(this));
    });
    //this.panelElement.hide();
};

onde.Onde.prototype.render = function (schema, data, opts) {
    this.documentSchema = schema || this.documentSchema;
    if (!this.documentSchema) {
        //CHECK: Bail out or freestyle object?
    }
    this.options = opts;
    this.documentInstance = data;
    this.panelElement.empty();
    this.instanceId = this._generateFieldId();
    this.initialRendering = true;
    this.renderObject(this.documentSchema, this.panelElement, this.instanceId, 
        this.documentInstance);
    this.initialRendering = false;
    if (opts.renderFinished) {
        opts.renderFinished(this.panelElement);
    }
};


onde.Onde.prototype.getSchema = function (schemaURL) {
    //TODO: Implement schema management
    return null;
};

onde.Onde.prototype.renderObject = function (schema, parentNode, namespace, data) {
    schema = schema || { type: "object", additionalProperties: true, _deletable: true };
    var props = schema.properties || {};
    var sortedKeys = [];
    for (var propName in props) {
        if (props.hasOwnProperty(propName) && 
          (!schema.primaryProperty || propName != schema.primaryProperty) && 
          sortedKeys.indexOf(propName) < 0) {
            sortedKeys.push(propName);
        }
    }
    // Last property to be collected is the primary, if any.
    if (schema.primaryProperty) {
        sortedKeys.unshift(schema.primaryProperty);
    }
    if (schema['extends']) {
        // Process schema extends
        for (var ixs = 0; ixs < schema['extends'].length; ++ixs) {
            var extSchema = this.getSchema(schema['extends'][ixs]);
            for (var propName in extSchema.properties) {
                if (propName in props) {
                } else {
                    props[propName] = extSchema.properties[propName];
                    sortedKeys.push(propName);
                }
            }
        }
    }
    var fieldId = 'field-' + this._fieldNameToID(namespace);
    var fieldValueId = 'fieldvalue-' + this._fieldNameToID(namespace);
    var baseNode = $('<ul></ul>').
        attr('id', fieldValueId).
        attr('data-type', 'object'); //CHECK: Always?
    if (schema.display) {
        baseNode.addClass(schema.display);
    }
    // Render all the properties defined in the schema
    var rowN = null;
    for (var ik = 0; ik < sortedKeys.length; ik++) {
        var propName = sortedKeys[ik];
        var valueData = data ? data[propName] : null;
        var rowN = this.renderObjectPropertyField(namespace, fieldId, 
            props[propName], propName, valueData);
        if (ik == 0) {
            rowN.addClass('first');
        }
        baseNode.append(rowN);
    }
    if (!schema.properties) {
        if (!('additionalProperties' in schema)) {
            schema.additionalProperties = true;
        }
    }
    var showEditBar = false;
    // Now check if the object has additional properties
    if (schema.additionalProperties) {
        //NOTE: additionalProperties could have 4 types of value: boolean, 
        // string (the name of the type), object (type info), array of types.
        var firstItem = rowN ? false : true;
        if (schema.additionalProperties === true) {
            for (var dKey in data) {
                //NOTE: No need to check the types. Will be done by the inner renderers.
                // Take only additional items
                if (sortedKeys.indexOf(dKey) === -1) {
                    rowN = this.renderObjectPropertyField(namespace, fieldId, 
                        { type: typeof data[dKey], additionalProperties: true, _deletable: true }, 
                        dKey, data[dKey]);
                    if (firstItem) {
                        rowN.addClass('first');
                        firstItem = false;
                    }
                    baseNode.append(rowN);
                }
            }
            showEditBar = true;
        } else if (Object.prototype.toString.call(schema.additionalProperties) == '[object Object]') {
            for(var dKey in data) {
                if(sortedKeys.indexOf(dKey) === -1) {
                    rowN = this.renderObjectPropertyField(namespace, fieldId,
                        schema.additionalProperties,
                        dKey, data[dKey]);
                }
            }
            if (firstItem) {
                rowN.addClass('first');
                firstItem = false;
            }
            baseNode.append(rowN);
            showEditBar = true;
        } else {
            //TODO: handle other additionalProperty values
        }
    }
    // Always the last if the object has any property
    if (rowN) {
        rowN.addClass('last');
    }
    parentNode.append(baseNode);
    var propertyTypes = [];
    // Gather the types available to additional properties
    if ('additionalProperties' in schema) {
        if (typeof schema.additionalProperties == 'string') {
            // Simply turn it into array (will be validated later)
            propertyTypes = [schema.additionalProperties];
        } else if (typeof schema.additionalProperties == 'object') {
            if (schema.additionalProperties instanceof Array) {
                propertyTypes = schema.additionalProperties;
            } else {
                propertyTypes = [schema.additionalProperties];
            }
        } else if (typeof schema.additionalProperties == 'boolean') {
            // Ignore (any?)
        } else {
            console.warn("Invalid additional properties type: " + (typeof schema.additionalProperties) + ".");
        }
    }
    // Toolbar if needed
    if (showEditBar) {
        var editBar = $('<div></div>').
            attr('id', fieldValueId + '-edit-bar').
            addClass('edit-bar').
            addClass('object');
        var inner = $('<small></small>');
        inner.append(this.tr('Add property: '));
        inner.append($('<input type="text" />').
            attr('id', fieldValueId + '-key').
            attr('placeholder', this.tr('Property name')));
        var addBtn = $('<button></button>').
            addClass('field-add').
            addClass('property-add').
            attr('data-field-id', fieldValueId).
            attr('data-object-namespace', namespace).
            text(this.tr('Add'));
        this.renderEditBarContent(propertyTypes, fieldValueId, inner, addBtn);
        inner.append(' ').append(addBtn);
        editBar.append(inner);
        parentNode.append(editBar);
    }
    return fieldId;
};


onde.Onde.prototype.renderEnumField = function (fieldName, fieldInfo, valueData) {
    // Renders field with enum property set.
    // The field will be rendered as dropdown.
    //TODO: If not exclusive, use combo box
    var fieldValueNode = null;
    var selectedValue = null;
    var hasSelected = false;
    // First, check if there's any data provided.
    // If so, check if the enum has the same value
    // If so, save the information
    if (typeof valueData === fieldInfo.type && fieldInfo.enum.indexOf(valueData) >= 0) {
        selectedValue = valueData;
        hasSelected = true;
    }
    // If there's no data provided, or the data is not valid, 
    // try to get selected value from the default.
    if (!hasSelected && typeof fieldInfo['default'] === fieldInfo.type && 
      fieldInfo.enum.indexOf(fieldInfo['default']) >= 0) {
        selectedValue = fieldInfo['default'];
        hasSelected = true;
    }
    if (fieldInfo && fieldInfo.enum) {
        var fieldBaseId = this._fieldNameToID(fieldName);
        if (fieldInfo.enum.length > 1) {
            var optN = null;
            fieldValueNode = $('<select></select>').
                attr('id', 'fieldvalue-' + fieldBaseId).
                attr('name', fieldName);
            if (!fieldInfo.required) {
                // Add the 'null' option if the field is not required
                fieldValueNode.append('<option value=""></option>');
            }
            for (var iev = 0; iev < fieldInfo.enum.length; iev++) {
                optN = $('<option></option>');
                optN.text(fieldInfo.enum[iev]);
                // Select the value
                if (hasSelected && selectedValue == fieldInfo.enum[iev]) {
                    optN.attr('selected', 'selected');
                }
                fieldValueNode.append(optN);
            }
        } else {
            fieldValueNode = $('<input type="text" />').
                attr('id', 'fieldvalue-' + fieldBaseId).
                attr('name', fieldName).
                attr('value', fieldInfo.enum[0]).
                attr('readonly', 'readonly');
        }
    }
    return fieldValueNode;
};
onde.Onde.prototype.renderEditBarContent = function (typeList, fieldValueId, baseNode, controlNode) {
    if (typeList.length == 1) {
        var optInfo = typeList[0];
        if (typeof optInfo == 'string') {
            // Option is provided as simple string
            controlNode.attr('data-object-type', optInfo);
        } else if (typeof optInfo == 'object') {
            if (optInfo instanceof Array) {
                console.error("InternalError: Type list is not supported");
            } else {
                if ('$ref' in optInfo) {
                    // Replace the option info with the referenced schema
                    optInfo = this.getSchema(optInfo['$ref']);
                    if (!optInfo) {
                        console.error("SchemaError: Could not resolve referenced schema");
                    }
                }
                if (optInfo) {
                    var optType = optInfo['type'];
                    //TODO: Check the type, it must be string and the value must be primitive
                    var optText = optInfo['name'] || optType;
                    var optSchemaName = 'schema-' + this._generateFieldId();
                    this.internalSchemas[optSchemaName] = optInfo;
                    controlNode.
                        attr('data-object-type', optType).
                        attr('data-schema-name', optSchemaName);
                }
            }
        }
    } else {
        // Render type list as type selector
        baseNode.append(this.renderTypeSelector(typeList, fieldValueId)).append(' ');
    }
}
onde.Onde.prototype.renderTypeSelector = function (typeList, fieldValueId) {
    // Renders type selector from type list.
    // This selector is for field (item or property) value is not restricted into one particular type.
    var typeOptions = $('<select></select>').
        attr('id', fieldValueId + '-type');
    if (typeList && typeList.length) {
        for (var iapt = 0; iapt < typeList.length; ++iapt) {
            var optInfo = typeList[iapt];
            if (typeof optInfo == 'string') {
                // The option is plain string, simply add it as an option.
                typeOptions.append($('<option/>').text(optInfo));
            } else if (typeof optInfo == 'object') {
                if (optInfo instanceof Array) {
                    // The option is an array.
                    console.error("SchemaError: Array in type list");
                    continue;
                }
                if ('$ref' in optInfo) {
                    // Replace the option info with the referenced schema
                    optInfo = this.getSchema(optInfo['$ref']);
                    if (!optInfo) {
                        console.error("SchemaError: Could not resolve referenced schema");
                        continue;
                    }
                }
                var optType = optInfo['type'];
                //TODO: Check the type, it must be string and the value must be primitive
                var optText = optInfo['name'] || optType;
                var optSchemaName = 'schema-' + this._generateFieldId();
                this.internalSchemas[optSchemaName] = optInfo;
                var optN = $('<option></option>').
                    attr('value', optType).
                    attr('data-schema-name', optSchemaName);
                optN.text(optText);
                typeOptions.append(optN);
            } else {
                console.error("SchemaError: Invalid type in type list");
            }
        }
    } else {
        //TODO: Any type
        for (var ipt = 0; ipt < onde.PRIMITIVE_TYPES.length; ++ipt) {
            typeOptions.append($('<option/>').text(onde.PRIMITIVE_TYPES[ipt]));
        }
    }
    return typeOptions;
};

onde.Onde.prototype._sanitizeFieldInfo = function (fieldInfo, valueData) {
    if (typeof fieldInfo == 'string' || fieldInfo instanceof String) {
        return { type: fieldInfo }; //TODO: Type specific defaults
    }
    if ((!fieldInfo || !fieldInfo.type || fieldInfo.type == 'any') && valueData) {
        fieldInfo = fieldInfo || {};
        fieldInfo.type = typeof valueData;
        if (fieldInfo.type == 'object') {
            if (valueData instanceof Array) {
                fieldInfo.type = 'array';
            } else {
                fieldInfo.additionalProperties = true;
            }
        }
    }
    //TODO: Deal with array type
    return fieldInfo;
}

onde.Onde.prototype.renderFieldValue = function (fieldName, fieldInfo, parentNode, valueData) {
    //TODO: Allow schema-less render (with multiline string as the fallback)
    //TODO: Read-only
    //TODO: Schema ref
    var fieldValueId = 'fieldvalue-' + this._fieldNameToID(fieldName);
    if ('$ref' in fieldInfo) {
        console.log(fieldInfo);
        if (valueData) {
            console.log(valueData);
        }
    }
    fieldInfo = this._sanitizeFieldInfo(fieldInfo, valueData);
    var fieldDesc = fieldInfo ? fieldInfo.description || fieldInfo.title : null;
    if (!fieldInfo || !fieldInfo.type || fieldInfo.type == 'any') {
        //TODO: Any!
        if (!fieldInfo) {
            parentNode.text("InternalError: Missing field information");
        } else if (!fieldInfo.type) {
            parentNode.text("InternalError: Missing type property");
        } else {
            parentNode.text("InternalError: Type of 'any' is currently not supported");
        }
    } else if (fieldInfo.type == 'string') {
        if (fieldInfo.readonly) {
            valueData = fieldInfo.value;
        }
        // String property
        var valueContainer = $('<span></span>').
            addClass('value');
        var fieldValueNode = null;
        if (fieldInfo.enum) {
            fieldValueNode = this.renderEnumField(fieldName, fieldInfo, valueData);
        } else {
            //TODO: Format
            if (fieldInfo.format == 'multiline') {
                fieldValueNode = $('<textarea></textarea>');
            } else {
                fieldValueNode = $('<input type="text" />');
            }
            fieldValueNode.
                attr('id', fieldValueId).
                attr('name', fieldName).
                addClass('value-input');
            if (typeof valueData == 'string') {
                fieldValueNode.val(valueData);
            }
            if (fieldInfo.title) {
                fieldValueNode.attr('title', fieldInfo.title);
            }
            if (fieldInfo['default']) {
                //TODO: Check the type
                fieldValueNode.attr('placeholder', fieldInfo['default']);
            }
            /*if (fieldInfo.format) {
                fieldValueNode.addClass(fieldInfo.format);
            }*/
        }
        fieldValueNode.attr('data-type', fieldInfo.type);
        /*if (fieldInfo.required) {
            fieldValueNode.attr('required', 'required');
        }*/
        if (fieldInfo.readonly) {
            fieldValueNode.attr('readonly', 'readonly');
        }
        valueContainer.append(fieldValueNode);
        if (fieldDesc) {
            valueContainer.append(' ').append($('<small></small>').
                addClass('description').
                append($('<em></em>').text(fieldDesc)));
        }
        parentNode.append(valueContainer);
    } else if (fieldInfo.type == 'number' || fieldInfo.type == 'integer') {
        // Numeric property (number or integer)
        var valueContainer = $('<span></span>').
            addClass('value');
        var fieldValueNode = null;
        if (fieldInfo.enum) {
            fieldValueNode = this.renderEnumField(fieldName, fieldInfo, valueData);
        } else {
            fieldValueNode = $('<input type="text" />').
                attr('id', fieldValueId).
                attr('name', fieldName).
                addClass('value-input');
            if (typeof valueData == "number") {
                fieldValueNode.val(valueData);
            } else if (typeof valueData == "string") {
                if (fieldInfo.type == 'integer') {
                    fieldValueNode.val(parseInt(valueData, 10));
                } else {
                    fieldValueNode.val(parseFloat(valueData));
                }
            }
            if (fieldInfo.title) {
                fieldValueNode.attr('title', fieldInfo.title);
            }
            if (fieldInfo['default']) {
                //TODO: Check the type
                fieldValueNode.attr('placeholder', fieldInfo['default']);
            }
        }
        fieldValueNode.attr('data-type', fieldInfo.type);
        valueContainer.append(fieldValueNode);
        if (fieldDesc) {
            valueContainer.append(' ').append($('<small></small>').
                addClass('description').
                append($('<em></em>').text(fieldDesc)));
        }
        parentNode.append(valueContainer);
    } else if (fieldInfo.type == 'boolean') {
        // Boolean property
        var valueContainer = $('<span></span>').
            addClass('value');
        //TODO: Check box (allow value replacements/mapping)
        var fieldValueNode = $('<input type="checkbox" />').
            attr('id', fieldValueId).
            attr('name', fieldName).
            addClass('value-input');
        if (valueData === 'on' || valueData === 'true' || valueData === 'checked' || 
          valueData === '1' || valueData === 1 || valueData === true) {
            fieldValueNode.attr('checked', 'checked');
        }
        if (fieldInfo.title) {
            fieldValueNode.attr('title', fieldInfo.title);
        }
        if ('default' in fieldInfo && fieldInfo['default']) {
            fieldValueNode.attr('checked', 'checked');
        }
        fieldValueNode.attr('data-type', fieldInfo.type);
        valueContainer.append(fieldValueNode);
        if (fieldDesc) {
            valueContainer.append(' ').append($('<small></small>').
                addClass('description').
                append($('<em></em>').text(fieldDesc)));
        }
        parentNode.append(valueContainer);
    } else if (fieldInfo.type == 'object') {
        //if (fieldInfo.additionalItems) {
        //  this.internalSchemas[fieldName] = fieldInfo;
        //}
        this.renderObject(fieldInfo, parentNode, fieldName, valueData);
    } else if (fieldInfo.type == 'array') {
        //TODO:FIXME:HACK:TEMP: Dummy array item (should make the renderer understands different kind of fieldInfo types)
        var itemSchema = { "type": "any" };
        var itemTypes = [];
        // Gather the types available to items
        if ('items' in fieldInfo) {
            if (typeof fieldInfo.items == 'string') {
                //TODO: Validate the value
                itemTypes = [fieldInfo.items];
                itemSchema = { "type": fieldInfo.items };
            } else if (typeof fieldInfo.items == 'object') {
                if (fieldInfo.items instanceof Array) {
                    itemTypes = fieldInfo.items;
                    //TODO
                    console.warn("Array with multiple types of item is currently not supported");
                } else {
                    itemTypes = [fieldInfo.items];
                    itemSchema = fieldInfo.items;
                }
            } else {
                console.warn("Invalid items type: " + (typeof fieldInfo.items) + " (" + fieldName + ")");
            }
        }
        var contN = $('<ol start="0"></ol>').
            attr('id', fieldValueId).
            attr('data-type', 'array');
        var lastIndex = 0;
        if (valueData) {
            for (var idat = 0; idat < valueData.length; idat++) {
                lastIndex++;
                var chRowN = this.renderListItemField(fieldName, itemSchema, 
                    lastIndex, valueData[idat]);
                if (idat == 0) {
                    chRowN.addClass('first');
                }
                if (idat == valueData.length - 1) {
                    chRowN.addClass('last');
                }
                contN.append(chRowN);
            }
        }
        parentNode.append(contN);
        var editBar = $('<div></div>').
            attr('id', fieldValueId + '-edit-bar').
            addClass('edit-bar').
            addClass('array');
        var inner = $('<small></small>');
        inner.append(this.tr("Add item: "));
        var addBtn = $('<button></button>').
            addClass('field-add').
            addClass('item-add').
            attr('data-field-id', fieldValueId).
            attr('data-object-namespace', fieldName).
            attr('data-last-index', lastIndex).
            text(this.tr("Add"));
        this.renderEditBarContent(itemTypes, fieldValueId, inner, addBtn);
        inner.append(' ').append(addBtn);
        editBar.append(inner);
        parentNode.append(editBar);
        return;
    } else if (fieldInfo.type == 'null') {
        var valueContainer = $('<span></span>').
            addClass('value');
        var fieldValueNode = $('<input type="hidden" />').
            attr('id', fieldValueId).
            attr('name', fieldName).
            addClass('value-input');
        fieldValueNode.attr('value', 'null');
        if (fieldInfo.title) {
            fieldValueNode.attr('title', fieldInfo.title);
        }
        fieldValueNode.attr('data-type', fieldInfo.type);
        valueContainer.append(fieldValueNode);
        if (fieldDesc) {
            valueContainer.append(' ').append($('<small></small>').
                addClass('description').
                append($('<em></em>').text(fieldDesc)));
        }
        parentNode.append(valueContainer);
    } else {
        var valueContainer = $('<span></span>').addClass('value').
            append(this.tr("InternalError: Unsupported property type: ")).
            append($('<tt></tt>').text(fieldInfo.type));
        parentNode.append(valueContainer);
    }
};

onde.Onde.prototype.renderObjectPropertyField = function (namespace, baseId, fieldInfo, propName, valueData) {
    var fieldName = namespace + this.fieldNamespaceSeparator + propName;
    var fieldBaseId = this._fieldNameToID(fieldName);
    var fieldId = 'field-' + fieldBaseId;
    var fieldValueId = 'fieldvalue-' + fieldBaseId;
    var fieldType = null;
    var collectionType = false;
    var rowN = $('<li></li>').
        attr('id', fieldId).
        addClass('field');
    fieldInfo = this._sanitizeFieldInfo(fieldInfo, valueData);
    if (fieldInfo) {
        //TODO: Support schema reference
        //TODO: Other types of type
        if (typeof fieldInfo == 'string') {
            fieldType = fieldInfo;
            fieldInfo = {};
        } else if (typeof fieldInfo == 'object') {
            if ('extends' in fieldInfo) {
                this.processSchemaExtends(fieldInfo);
            }
            if (fieldInfo instanceof Array) {
                //TODO: Union
            } else if (typeof fieldInfo.type == 'string') {
                fieldType = fieldInfo.type;
            } else {
                console.warn("Invalid field info type: " + fieldInfo.type);
            }
        } else {
            console.warn("Invalid field info type: " + (typeof fieldInfo.type));
        }
    } else {
        fieldInfo = {};
    }
    if (onde.PRIMITIVE_TYPES.indexOf(fieldType) >= 0) {
        rowN.addClass(fieldType);
    } else {
        rowN.addClass('ref');
    }
    collectionType = (fieldType == 'object' || fieldType == 'array');
    //rowN.addClass('property');
    //rowN.addClass(baseId + '-property');
    var labelN = $('<label></label>').
        attr('for', fieldValueId).
        addClass('field-name');
    rowN.append(labelN);
    var valN = null;
    if ((fieldType == 'object' && fieldInfo.display != 'inline') || fieldType == 'array') {
        // Some special treatments for collapsible field
        rowN.addClass('collapsible');
        labelN.addClass('collapser');
        labelN.attr('data-fieldvalue-container-id', 'fieldvalue-container-' + fieldBaseId);
        valN = $('<div></div>').
            attr('id', 'fieldvalue-container-' + fieldBaseId).
            addClass('collapsible-panel').
            addClass('fieldvalue-container');
        rowN.append(valN);
        if (this.initialRendering && this.options.collapsedCollapsibles) {
            valN.hide();
            labelN.addClass('collapsed');
        }
    } else {
        valN = rowN;
    }
    // Use the label if provided. Otherwise, use property name.
    var labelText = fieldInfo.label || propName;
    //TODO: Not only the root
    if ((namespace === '' || namespace.indexOf('.') < 0) && 
      this.documentSchema.primaryProperty && 
      this.documentSchema.primaryProperty == propName) {
        // Primary property
        rowN.addClass('primary');
        labelN.append($('<strong></strong>').text(labelText));
    } else {
        labelN.text(labelText);
    }
    if (fieldInfo.required || rowN.hasClass('primary')) {
        // Required field
        labelN.append($('<span></span>').
            addClass('required-marker').
            attr('title', this.tr("Required field")).
            text('*'));
    }
    labelN.append(': ');
    var actionMenu = '';
    //TODO: More actions (only if qualified)
    if (fieldInfo._deletable) {
        actionMenu = $('<small></small>').append(' ').append($('<button></button>').
            attr('title', this.tr("Delete item")).
            attr('data-id', fieldId).
            addClass('field-delete').
            text(this.tr("delete"))
            ).append(' ');
    }
    if (collectionType) {
        labelN.append(actionMenu);
    }
    if (labelN.hasClass('collapser')) {
        // Add description to label if the field is collapsible
        var fieldDesc = fieldInfo.description || fieldInfo.title;
        if (fieldDesc) {
            labelN.append(' ').append($('<small></small>')
                .addClass('description')
                .append($('<em></em>')
                .text(fieldDesc)
                ));
        }
    }
    if (fieldInfo['$ref']) {
        //TODO: Deal with schema reference
        valN.append($('<span></span>').addClass('value').text(fieldInfo['$ref']));
    } else if (onde.PRIMITIVE_TYPES.indexOf(fieldType) < 0) {
        //TODO: Deal with schema reference (and unsupported types)
        valN.append($('<span></span>').addClass('value').text(fieldType));
    } else {
        if (valueData && namespace === '' && this.documentSchema.primaryProperty == propName) {
            // Primary property is not editable
            valN.append($('<span></span>').addClass('value').append($('<strong></strong>').text(valueData)));
            valN.append($('<input type="hidden" />').attr('name', fieldName).attr('value', valueData));
        } else {
            this.renderFieldValue(fieldName, fieldInfo, valN, valueData);
            if (!collectionType) {
                valN.append(actionMenu);
            }
        }
    }
    return rowN;
};

onde.Onde.prototype.renderListItemField = function (namespace, fieldInfo, index, valueData) {
    var itemId = index;
    var fieldName = namespace + '[' + itemId + ']';
    var fieldBaseId = this._fieldNameToID(fieldName);
    var fieldId = 'field-' + fieldBaseId;
    var fieldValueId = 'fieldvalue-' + fieldBaseId;
    var collectionType = false;
    var rowN = $('<li></li>').
        attr('id', fieldId).
        addClass('field').
        addClass('array-item');
    fieldInfo = this._sanitizeFieldInfo(fieldInfo, valueData);
    if (typeof fieldInfo.type == 'string') {
        rowN.addClass(fieldInfo.type);
        collectionType = (fieldInfo.type == 'object' || fieldInfo.type == 'array');
    }
    var deleterShown = false;
    var labelN = null;
    var valN = rowN;
    if (fieldInfo.type == 'object' && fieldInfo.display == 'inline') {
    } else {
        var labelN = $('<label></label>').
            attr('for', fieldValueId).
            addClass('field-name').
            addClass('array-index');
        rowN.append(labelN);
        labelN.append('&nbsp;');
        if ((fieldInfo.type == 'object' && fieldInfo.display != 'inline') || fieldInfo.type == 'array') {
            rowN.addClass('collapsible');
            labelN.addClass('collapser');
            valN = $('<div></div>').
                attr('id', 'fieldvalue-container-' + fieldBaseId).
                addClass('collapsible-panel').
                addClass('fieldvalue-container');
            rowN.append(valN);
            if (this.initialRendering && this.options.collapsedCollapsibles) {
                valN.hide();
                labelN.addClass('collapsed');
            }
        }
        //labelN.append(idat + ': ');
        labelN.append('&nbsp; ');
        //TODO: More actions (only if qualified)
        if (collectionType) {
            labelN.append($('<small></small>').append(' ').append($('<button></button>').
                attr('title', this.tr("Delete item")).
                attr('data-id', fieldId).
                addClass('field-delete').
                text(this.tr("delete"))
                ).append(' '));
            deleterShown = true;
        }
    }
    if (rowN.hasClass('collapsible') && labelN) {
        labelN.attr('data-fieldvalue-container-id', 'fieldvalue-container-' + fieldBaseId);
    }
    this.renderFieldValue(fieldName, fieldInfo, valN, valueData);
    if (!deleterShown) {
        valN.append($('<small></small>').append(' ').append($('<button></button>').
            attr('title', this.tr("Delete item")).
            attr('data-id', fieldId).
            addClass('field-delete').
            text(this.tr("delete"))
            ).append(' '));
    }
    return rowN;
};


onde.Onde.prototype._getFieldInfo = function (handle) {
    var baseId = handle.attr('data-field-id');
    if (!baseId) {
        console.error('Internal error: element has no field id data');
        return;
    }
    var schemaName = null;
    // Element which contains information about the field
    var typeSel = $('#' + baseId + '-type');
    if (typeSel.length) {
        typeSel = typeSel[0];
        if (typeSel.options) {
            // The type is from a selection
            schemaName = $(typeSel.options[typeSel.selectedIndex]).attr('data-schema-name');
        } else {
            // Single type
            schemaName = typeSel.attr('data-schema-name');
        }
    }
    if (!schemaName) {
        // The last possible place to get the name of the schema
        schemaName = handle.attr('data-schema-name');
    }
    // Return the schema (if the name is valid)
    return schemaName ? this.internalSchemas[schemaName] : null;
};


onde.Onde.prototype.onAddObjectProperty = function (handle) {
    //TODO: Check if the key already used
    var baseId = handle.attr('data-field-id');
    var propName = $('#' + baseId + '-key').val();
    if (!propName) {
        //TODO: Nice [unobstrusive] error message
        alert("Property name must not be empty");
        return;
    }
    if (!propName.match(/^[a-z_][a-z0-9_]+$/i)) {
        //TODO: Nice [unobstrusive] error message
        alert("Invalid property name");
        return;
    }
    var namespace = handle.attr('data-object-namespace');
    var ftype = handle.attr('data-object-type') || $('#' + baseId + '-type').val();
    var fieldInfo = this._getFieldInfo(handle);
    if (!fieldInfo) {
        // No schema found, build it
        fieldInfo = { type: ftype, _deletable: true };
        if (ftype == 'object') {
            // Special case for object, add additional property
            fieldInfo['additionalProperties'] = true;
        }
    } else {
        // Mark as deletable
        fieldInfo._deletable = true;
    }
    var baseNode = $('#' + baseId);
    var rowN = this.renderObjectPropertyField(namespace, baseId, fieldInfo, propName);
    var siblings = baseNode.children('li.field'); //NOTE: This may weak
    if (siblings.length == 0) {
        rowN.addClass('first');
    }
    siblings.removeClass('last');
    rowN.addClass('last');
    baseNode.append(rowN);
    $('#' + baseId + '-key').val('');
    rowN.hide();
    rowN.fadeIn('fast', function () { rowN.find('input').first().focus(); });
};

onde.Onde.prototype.onAddListItem = function (handle) {
    var baseId = handle.attr('data-field-id');
    var lastIndex = parseInt(handle.attr('data-last-index'), 10) + 1;
    handle.attr('data-last-index', lastIndex);
    var namespace = handle.attr('data-object-namespace');
    var ftype = handle.attr('data-object-type') || $('#' + baseId + '-type').val();
    var fieldInfo = this._getFieldInfo(handle);
    if (!fieldInfo) {
        // No schema found, build it
        fieldInfo = { type: ftype };
        if (ftype == 'object') {
            // Special case for object, add additional property
            fieldInfo['additionalProperties'] = true;
        }
    }
    // Array item is always deletable (?!)
    var baseNode = $('#' + baseId);
    var rowN = this.renderListItemField(namespace, fieldInfo, lastIndex);
    var siblings = baseNode.children('li.array-item');
    if (siblings.length == 0) {
        rowN.addClass('first');
    }
    siblings.removeClass('last');
    rowN.addClass('last');
    baseNode.append(rowN);
    $('#' + baseId + '-key').val('');
    rowN.hide();
    rowN.fadeIn('fast', function () { rowN.find('input').first().focus(); });
};

onde.Onde.prototype.onFieldTypeChanged = function (handle) {
    //TODO
    //this.renderFieldValue(handle.attr('name'), { type: handle.val(), items: { type: 'string' } }, handle.parent());
};

onde.Onde.prototype._generateFieldId = function () {
    return 'f' + parseInt(Math.random() * 1000000, 10);
};
onde.Onde.prototype._fieldNameToID = function (fieldName) {
    // Replace dots with hyphens
    //TODO: Replace all other invalid characters for HTML element ID.
    var t = fieldName.replace(/\./g, '-');
    return t.replace(/\[/g, '_').replace(/\]/g, '');
};


onde.Onde.prototype._buildProperty = function (propName, propInfo, path, formData) {
    var result = { data: null, noData: true, errorCount: 0, errorData: null };
    var fieldName = path + this.fieldNamespaceSeparator + propName;
    var fieldBaseId = this._fieldNameToID(fieldName);
    var fieldId = 'field-' + fieldBaseId;
    var ptype = 'any';
    if (propInfo && propInfo.type) {
        ptype = propInfo.type;
    }
    var dataType = ptype;
    if (ptype == 'any') {
        var fvn = $('#fieldvalue-' + fieldBaseId);
        if (fvn.length) {
            dataType = fvn.attr('data-type');
        }
        if (!dataType || dataType == 'any') {
            console.log(propName);
            //TODO: Fallback: string?
            //TODO: Need to attach the type to the field for array and object
        }
    }
    if (dataType == 'object') {
        result = this._buildObject(propInfo, fieldName, formData);
    } else if (dataType == 'array') {
        var itemIndices = [];
        var baseFieldName = fieldName + '[';
        //NOTE: Here we rely on the object properties ordering (TODO: more reliable array ordering)
        // We use object to create an array with unique items (a set)
        var tmpIdx = {};
        for (var fname in formData) {
            if (fname.startsWith(baseFieldName)) {
                tmpIdx[fname.slice(baseFieldName.length).split(']', 1)[0]] = true;
            }
        }
        for (var fname in tmpIdx) {
            itemIndices.push(parseInt(fname, 10));
        }
        itemIndices = itemIndices.sort(function (a,b) {return a - b});
        var lsData = [];
        var lsErrCount = 0;
        var lsErrData = [];
        for (var iidx = 0; iidx < itemIndices.length; ++iidx) {
            var cRes = this._buildProperty(propName + '[' + itemIndices[iidx] + ']', 
                propInfo ? propInfo.items : null, path, formData);
            lsData.push(cRes.data);
            if (cRes.errorCount) {
                lsErrCount += cRes.errorCount;
                lsErrData.push(cRes.errorData);
            }
        }
        result.data = lsData;
        result.noData = result.data.length == 0;
        if (lsErrCount) {
            result.errorCount += lsErrCount;
            result.errorData = lsErrData;
        }
        if (propInfo.required && !result.data.length) {
            result.errorCount += 1;
            //TODO: How to attach the error information here?
            result.errorData = 'value-required';
        }
    } else {
        var valData = null;
        if (formData) {
            valData = formData[fieldName];
        }
        if (dataType == 'boolean') {
            //NOTE: This makes boolean property always present
            result.data = (valData === 'on' || 
                valData === 'true' || valData === 'checked' || 
                valData === '1' || valData === 1 || valData === true);
            result.noData = false;
        } else if (valData) {
            result.noData = false;
            if (dataType == 'integer') {
                result.data = parseInt(valData, 10); //TODO: Radix depends on the radix specified by the schema
                if (isNaN(result.data)) {
                    result.errorCount += 1;
                    result.errorData = 'value-error';
                }
            } else if (dataType == 'number') {
                result.data = parseFloat(valData);
                if (isNaN(result.data)) {
                    result.errorCount += 1;
                    result.errorData = 'value-error';
                }
            } else if (dataType == 'string') {
                result.data = valData;
            } else if (dataType == 'null') {
                result.data = null;
            } else {
                console.warn("Unsupported type: " + dataType + " (" + fieldName + ")");
                result.errorCount += 1;
                result.errorData = 'type-error';
            }
        } else {
            if (propInfo && propInfo.required) {
                if (typeof propInfo['default'] != 'undefined') {
                    //TODO: Check the value (the flag below is fake)
                    result.noData = false;
                    result.data = propInfo['default'];
                } else {
                    result.errorCount += 1;
                    result.errorData = 'value-required';
                }
            }
            if (!propInfo) {
                console.log(fieldName);
            }
        }
    }
    if (result.errorCount > 0) {
        // This field has one or more error
        $('#' + fieldId).addClass('error');
        //TODO: Print the errors (insert them into the description)
    }
    return result;
};

onde.Onde.prototype._buildObject = function (schema, path, formData) {
    var result = { data: {}, errorCount: 0, errorData: {}, noData: true };
    var props = schema ? schema.properties || {} : {};
    for (var propName in props) {
        if (!props.hasOwnProperty(propName)) {
            continue;
        }
        var propInfo = props[propName];
        var cRes = this._buildProperty(propName, propInfo, path, formData);
        if (!cRes.noData) {
            result.data[propName] = cRes.data;
            result.noData = false;
        }
        if (cRes.errorCount) {
            result.errorCount += cRes.errorCount;
            result.errorData[propName] = cRes.errorData;
        }
    }
    if (!schema || schema.additionalProperties || !schema.properties) {
        //TODO: Validate againts schema for additional properties
        var cpath = path + this.fieldNamespaceSeparator;
        for (var fieldName in formData) {
            var valData = formData[fieldName];
            if (!valData) {
                continue;
            }
            // Filter the form data
            if (fieldName.startsWith(cpath)) {
                var propName = fieldName.slice(cpath.length);
                var dataType = null;
                var dotIdx = propName.indexOf(this.fieldNamespaceSeparator);
                var brkIdx = propName.indexOf('[');
                if (dotIdx > 0 && brkIdx > 0) {
                    dataType = (dotIdx < brkIdx) ? 'object' : 'array';
                } else if (dotIdx > 0) {
                    dataType = 'object';
                } else if (brkIdx > 0) {
                    dataType = 'array';
                }
                if (dataType === 'object') {
                    var bPropName = propName.split(this.fieldNamespaceSeparator, 1)[0];
                    if (!(bPropName in result.data)) {
                        var cRes = this._buildProperty(bPropName, 
                            { type: 'object', additionalProperties: true }, path, formData);
                        if (!cRes.noData) {
                            result.data[bPropName] = cRes.data;
                        }
                        if (cRes.errorCount) {
                            result.errorCount += cRes.errorCount;
                            result.errorData[bPropName] = cRes.errorData;
                        }
                    }
                } else if (dataType === 'array') {
                    var bPropName = propName.split('[', 1)[0];
                    if (!(bPropName in result.data)) {
                        var cRes = this._buildProperty(bPropName, { type: 'array' }, path, formData);
                        if (!cRes.noData) {
                            result.data[bPropName] = cRes.data;
                        }
                        if (cRes.errorCount) {
                            result.errorCount += cRes.errorCount;
                            result.errorData[bPropName] = cRes.errorData;
                        }
                    }
                } else {
                    // Get the type from the element
                    dataType = $('#fieldvalue-' + this._fieldNameToID(fieldName)).attr('data-type');
                    if (dataType == 'integer') {
                        var dVal = parseInt(valData, 10); //TODO: Radix depends on the radix specified by the schema
                        if (isNaN(dVal)) {
                            result.errorCount += 1;
                            result.errorData[propName] = 'value-error';
                        } else {
                            result.data[propName] = dVal;
                        }
                    } else if (dataType == 'number') {
                        var dVal = parseFloat(valData);
                        if (isNaN(dVal)) {
                            result.errorCount += 1;
                            result.errorData[propName] = 'value-error';
                        } else {
                            result.data[propName] = dVal;
                        }
                    } else if (dataType == 'boolean') {
                        result.data[propName] = (valData === 'on' || 
                            valData === 'true' || valData === 'checked' || 
                            valData === '1' || valData === 1 || valData === true);
                    } else if (dataType == 'string') {
                        result.data[propName] = valData;
                    } else if (dataType == 'null') {
                        result.data[propName] = undefined;
                    } else {
                        console.warn("Unsupported type: " + dataType + " (" + propName + ")");
                        result.errorCount += 1;
                        result.errorData[propName] = 'type-error';
                    }
                }
            }
        }
    }
    var hasProp = false;
    for (var propName in result.data) {
        if (result.data.hasOwnProperty(propName)) {
            hasProp = true;
            break;
        }
    }
    result.noData = !hasProp;
    if (!hasProp) {
        if (schema && schema.required) {
            result.errorCount += 1;
            result.errorData = 'value-required';
        }
    }
    return result;
};

onde.Onde.prototype.getData = function (opts) {
    var formData = {};
    var fields = this.formElement.serializeArray();
    for (var i = 0; i < fields.length; i++) {
        formData[fields[i].name] = fields[i].value;
    }
    if (formData.next) {
        delete formData.next;
    }
    this.formElement.find('.onde-panel .error').removeClass('error');
    return this._buildObject(this.documentSchema, this.instanceId, formData);
};


onde.Onde.prototype.tr = function (text) {
    // Translations go here
    return text;
};

onde.Onde.prototype.processSchemaExtends = function (schema) {
    var extSchema = schema['extends'];
    for (var propName in extSchema) {
        if (!(propName in schema)) {
            schema[propName] = extSchema[propName];
        }
    }
};
