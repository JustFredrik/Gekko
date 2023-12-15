
function __gekko_pubsub_subscribe(_source, _target, _event, _callback) {
	var _source_uid = _source.get_uid();
	var _target_uid = _target.get_uid();
	var _e = __gekko_pubsub_get_event(_target_uid, _event);
	
	variable_struct_set(_e, _source_uid, {
		source		: _source_uid,
		target		: _target_uid,
		event		: _event,
		callback	: _callback
	});
}


function __gekko_pubsub_unsubscribe(_source, _target, _event) {
	var _source_uid = _source.get_uid();
	var _target_uid = _target.get_uid();
	var _e = __gekko_pubsub_get_event(_target_uid, _event);
	var _var_array = struct_get_names(_e);
	
	var _len = array_length(_var_array);
	for(var _i = 0; _i < _len; _i++){
		if _source_uid == _var_array[_i] {
			array_delete(_var_array, _i, 1);
			return 1;
		}
	}
		
	return -1;
}


function __gekko_pubsub_publish(_target, _event, _data={}) {
	var _target_uid = _target.get_uid();
	var _e = __gekko_pubsub_get_event(_target_uid, _event);
	var _var_array = struct_get_names(_e);
	var _len = array_length(_var_array);
	
	for(var _i = 0; _i < _len; _i++) {
		struct_get(_e, _var_array[_i]).callback();
	}
}


function __gekko_pubsub_get_event(_target_uid, _event) {
	var _s = __gekko_get_manager().pubsub_struct;

	if not variable_struct_exists(_s, _target_uid) {
		variable_struct_set(_s, _target_uid, {});
	}
	
	var _t = variable_struct_get(_s, _target_uid);
	
	if not variable_struct_exists(_t, _event) {
		variable_struct_set(_t, _event, {});
	}
	
	return variable_struct_get(_t, _event);
}
	