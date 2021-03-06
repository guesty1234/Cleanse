#!/usr/bin/env ruby

require 'erb'
require 'pathname'


class Node
	attr_accessor :case_name, :class_name, :case_var_name

	def initialize(case_name, class_name, case_var_name=case_name)
		@case_name = case_name
		@class_name = class_name
		@case_var_name = case_var_name
	end
end

class Renderer
	attr_accessor :decl_items

	def initialize(decl_items)
		@decl_items = decl_items
	end

	def get_binding
    	binding()
  	end
end

NODES = [
	Node.new("source_file", "SourceFileDecl"),
	Node.new("import_decl", "ImportDecl"),
	Node.new("var_decl", "VarDecl"),
	Node.new("enum_case_decl", "EnumCaseDecl"),
	Node.new("enum_decl", "EnumDecl"),
	Node.new("enum_element_decl", "EnumElementDecl"),
	Node.new("struct_decl", "StructDecl"),
	Node.new("class_decl", "ClassDecl"),
	Node.new("pattern_binding_decl", "PatternBindingDecl"),
	Node.new("subscript_decl", "SubscriptDecl"),
	Node.new("func_decl", "FuncDecl"),
	Node.new("accessor_decl", "AccessorDecl"),
	Node.new("constructor_decl", "ConstructorDecl"),
	Node.new("destructor_decl", "DestructorDecl"),
	Node.new("top_level_code_decl", "TopLevelCodeDecl"),
	Node.new("if_config_decl", "IfConfigDecl"),
	Node.new("pound_diagnostic_decl", "PoundDiagnosticDecl"),
	Node.new("precedence_group_decl", "PrecedenceGroupDecl"),
	Node.new("infix_operator_decl", "InfixOperatorDecl"),
	Node.new("prefix_operator_decl", "PrefixOperatorDecl"),
	Node.new("postfix_operator_decl", "PostfixOperatorDecl"),
	Node.new("missing_member_decl", "MissingMemberDecl"),
	Node.new("declref_expr", "DeclrefExpr"),
	Node.new("overloaded_decl_ref_expr", "OverloadedDeclRefExpr"),
	Node.new("unresolved_decl_ref_expr", "UnresolvedDeclRefExpr"),
	Node.new("pattern_expr", "PatternExpr"),
	Node.new("semantic_expr", "SemanticExpr"),
	Node.new("error_expr", "ErrorExpr"),
	Node.new("code_completion_expr", "CodeCompletionExpr"),
	Node.new("nil_literal_expr", "NilLiteralExpr"),
	Node.new("integer_literal_expr", "IntegerLiteralExpr"),
	Node.new("float_literal_expr", "FloatLiteralExpr"),
	Node.new("boolean_literal_expr", "BooleanLiteralExpr"),
	Node.new("string_literal_expr", "StringLiteralExpr"),
	Node.new("interpolated_string_literal_expr", "InterpolatedStringLiteralExpr"),
	Node.new("magic_identifier_literal_expr", "MagicIdentifierLiteralExpr"),
	Node.new("discard_assignment_expr", "DiscardAssignmentExpr"),
	Node.new("super_ref_expr", "SuperRefExpr"),
	Node.new("type_expr", "TypeExpr"),
	Node.new("other_constructor_ref_expr", "OtherConstructorRefExpr"),
	Node.new("unresolved_specialize_expr", "UnresolvedSpecializeExpr"),
	Node.new("member_ref_expr", "MemberRefExpr"),
	Node.new("dynamic_member_ref_expr", "DynamicMemberRefExpr"),
	Node.new("unresolved_member_expr", "UnresolvedMemberExpr"),
	Node.new("dot_self_expr", "DotSelfExpr"),
	Node.new("paren_expr", "ParenExpr"),
	Node.new("tuple_expr", "TupleExpr"),
	Node.new("array_expr", "ArrayExpr"),
	Node.new("dictionary_expr", "DictionaryExpr"),
	Node.new("subscript_expr", "SubscriptExpr"),
	Node.new("keypath_application_expr", "KeypathApplicationExpr"),
	Node.new("dynamic_subscript_expr", "DynamicSubscriptExpr"),
	Node.new("unresolved_dot_expr", "UnresolvedDotExpr"),
	Node.new("tuple_element_expr", "TupleElementExpr"),
	Node.new("destructure_tuple_expr", "DestructureTupleExpr"),
	Node.new("unresolvedtype_conversion_expr", "UnresolvedtypeConversionExpr"),
	Node.new("function_conversion_expr", "FunctionConversionExpr"),
	Node.new("covariant_function_conversion_expr", "CovariantFunctionConversionExpr"),
	Node.new("covariant_return_conversion_expr", "CovariantReturnConversionExpr"),
	Node.new("implicitly_unwrapped_function_conversion_expr", "ImplicitlyUnwrappedFunctionConversionExpr"),
	Node.new("underlying_to_opaque_expr", "UnderlyingToOpaqueExpr"),
	Node.new("erasure_expr", "ErasureExpr"),
	Node.new("any_hashable_erasure_expr", "AnyHashableErasureExpr"),
	Node.new("conditional_bridge_from_objc_expr", "ConditionalBridgeFromObjcExpr"),
	Node.new("bridge_from_objc_expr", "BridgeFromObjcExpr"),
	Node.new("bridge_to_objc_expr", "BridgeToObjcExpr"),
	Node.new("load_expr", "LoadExpr"),
	Node.new("metatype_conversion_expr", "MetatypeConversionExpr"),
	Node.new("collection_upcast_expr", "CollectionUpcastExpr"),
	Node.new("derived_to_base_expr", "DerivedToBaseExpr"),
	Node.new("archetype_to_super_expr", "ArchetypeToSuperExpr"),
	Node.new("inout_expr", "InoutExpr"),
	Node.new("vararg_expansion_expr", "VarargExpansionExpr"),
	Node.new("force_try_expr", "ForceTryExpr"),
	Node.new("optional_try_expr", "OptionalTryExpr"),
	Node.new("try_expr", "TryExpr"),
	Node.new("sequence_expr", "SequenceExpr"),
	Node.new("closure_expr", "ClosureExpr"),
	Node.new("autoclosure_expr", "AutoclosureExpr"),
	Node.new("metatype_expr", "MetatypeExpr"),
	Node.new("opaque_value_expr", "OpaqueValueExpr"),
	Node.new("property_wrapper_value_placeholder_expr", "PropertyWrapperValuePlaceholderExpr"),
	Node.new("default_argument_expr", "DefaultArgumentExpr"),
	Node.new("call_expr", "CallExpr"),
	Node.new("prefix_unary_expr", "PrefixUnaryExpr"),
	Node.new("postfix_unary_expr", "PostfixUnaryExpr"),
	Node.new("binary_expr", "BinaryExpr"),
	Node.new("dot_syntax_call_expr", "DotSyntaxCallExpr"),
	Node.new("constructor_ref_call_expr", "ConstructorRefCallExpr"),
	Node.new("forced_checked_cast_expr", "ForcedCheckedCastExpr"),
	Node.new("conditional_checked_cast_expr", "ConditionalCheckedCastExpr"),
	Node.new("is_subtype_expr", "IsSubtypeExpr"),
	Node.new("coerce_expr", "CoerceExpr"),
	Node.new("rebind_self_in_constructor_expr", "RebindSelfInConstructorExpr"),
	Node.new("if_expr", "IfExpr"),
	Node.new("assign_expr", "AssignExpr"),
	Node.new("enum_is_case_expr", "EnumIsCaseExpr"),
	Node.new("unresolved_pattern_expr", "UnresolvedPatternExpr"),
	Node.new("bind_optional_expr", "BindOptionalExpr"),
	Node.new("optional_evaluation_expr", "OptionalEvaluationExpr"),
	Node.new("force_value_expr", "ForceValueExpr"),
	Node.new("open_existential_expr", "OpenExistentialExpr"),
	Node.new("make_temporarily_escapable_expr", "MakeTemporarilyEscapableExpr"),
	Node.new("editor_placeholder_expr", "EditorPlaceholderExpr"),
	Node.new("lazy_initializer_expr", "LazyInitializerExpr"),
	Node.new("objc_selector_expr", "ObjcSelectorExpr"),
	Node.new("keypath_expr", "KeypathExpr"),
	Node.new("key_path_dot_expr", "KeyPathDotExpr"),
	Node.new("one_way_expr", "OneWayExpr"),
	Node.new("tap_expr", "TapExpr"),
	Node.new("pattern_paren", "PatternParen"),
	Node.new("pattern_named", "PatternNamed"),
	Node.new("pattern_any", "PatternAny"),
	Node.new("pattern_typed", "PatternTyped"),
	Node.new("pattern_is", "PatternIs"),
	Node.new("pattern_let", "PatternLet"),
	Node.new("pattern_var", "PatternVar"),
	Node.new("pattern_enum_element", "PatternEnumElement"),
	Node.new("pattern_optional_some", "PatternOptionalSome"),
	Node.new("pattern_bool", "PatternBool"),
	Node.new("extension_decl", "ExtensionDecl"),
	Node.new("typealias", "Typealias", "`typealias`"),
	Node.new("generic_type_param", "GenericTypeParam"),
	Node.new("associated_type_decl", "AssociatedTypeDecl"),
	Node.new("`protocol`", "ProtocolInst"),
	Node.new("param_decl", "ParamDecl"),
	Node.new("module", "module"),
	Node.new("brace_stmt", "BraceStmt"),
	Node.new("return_stmt", "ReturnStmt"),
	Node.new("yield_stmt", "YieldStmt"),
	Node.new("defer_stmt", "DeferStmt"),
	Node.new("if_stmt", "IfStmt"),
	Node.new("guard_stmt", "GuardStmt"),
	Node.new("do_stmt", "DoStmt"),
	Node.new("while_stmt", "WhileStmt"),
	Node.new("repeat_while_stmt", "RepeatWhileStmt"),
	Node.new("for_each_stmt", "ForEachStmt"),
	Node.new("break_stmt", "BreakStmt"),
	Node.new("continue_stmt", "ContinueStmt"),
	Node.new("fallthrough_stmt", "FallthroughStmt"),
	Node.new("switch_stmt", "SwitchStmt"),
	Node.new("case_stmt", "CaseStmt"),
	Node.new("fail_stmt", "FailStmt"),
	Node.new("throw_stmt", "ThrowStmt"),
	Node.new("pound_assert", "PoundAssert"),
	Node.new("do_catch_stmt", "DoCatchStmt"),
	Node.new("object_literal", "ObjectLiteral"),
	Node.new("type_error", "TypeError"),
	Node.new("type_attributed", "TypeAttributed"),
	Node.new("type_ident", "TypeIdent"),
	Node.new("type_function", "TypeFunction"),
	Node.new("type_array", "TypeArray"),
	Node.new("type_dictionary", "TypeDictionary"),
	Node.new("type_tuple", "TypeTuple"),
	Node.new("type_composite", "TypeComposite"),
	Node.new("type_metatype", "TypeMetatype"),
	Node.new("type_protocol", "TypeProtocol"),
	Node.new("type_inout", "TypeInout"),
	Node.new("type_shared", "TypeShared"),
	Node.new("type_owned", "TypeOwned"),
	Node.new("type_optional", "TypeOptional"),
	Node.new("type_implicitly_unwrapped_optional", "TypeImplicitlyUnwrappedOptional"),
	Node.new("type_opaque_return", "TypeOpaqueReturn"),
	Node.new("type_fixed", "TypeFixed"),
	Node.new("sil_box", "SilBox"),
	Node.new("error_type", "ErrorType"),
	Node.new("builtin_integer_type", "BuiltinIntegerType"),
	Node.new("builtin_float_type", "BuiltinFloatType"),
	Node.new("builtin_vector_type", "BuiltinVectorType"),
	Node.new("type_alias_type", "TypeAliasType"),
	Node.new("paren_type", "ParenType"),
	Node.new("tuple_type", "TupleType"),
	Node.new("enum_type", "EnumType"),
	Node.new("struct_type", "StructType"),
	Node.new("class_type", "ClassType"),
	Node.new("protocol_type", "ProtocolType"),
	Node.new("metatype_type", "MetatypeType"),
	Node.new("existential_metatype_type", "ExistentialMetatypeType"),
	Node.new("module_type", "ModuleType"),
	Node.new("dynamic_self_type", "DynamicSelfType"),
	Node.new("primary_archetype_type", "PrimaryArchetypeType"),
	Node.new("nested_archetype_type", "NestedArchetypeType"),
	Node.new("opened_archetype_type", "OpenedArchetypeType"),
	Node.new("opaque_type", "OpaqueType"),
	Node.new("generic_type_param_type", "GenericTypeParamType"),
	Node.new("dependent_member_type", "DependentMemberType"),
	Node.new("function_type", "FunctionType"),
	Node.new("generic_function_type", "GenericFunctionType"),
	Node.new("sil_function_type", "SilFunctionType"),
	Node.new("sil_block_storage_type", "SilBlockStorageType"),
	Node.new("sil_box_type", "SilBoxType"),
	Node.new("array_slice_type", "ArraySliceType"),
	Node.new("optional_type", "OptionalType"),
	Node.new("dictionary_type", "DictionaryType"),
	Node.new("protocol_composition_type", "ProtocolCompositionType"),
	Node.new("lvalue_type", "LvalueType"),
	Node.new("inout_type", "InoutType"),
	Node.new("unbound_generic_type", "UnboundGenericType"),
	Node.new("bound_generic_class_type", "BoundGenericClassType"),
	Node.new("bound_generic_struct_type", "BoundGenericStructType"),
	Node.new("bound_generic_enum_type", "BoundGenericEnumType"),
	Node.new("type_variable_type", "TypeVariableType"),
	Node.new("pattern_tuple", "PatternTuple"),
	Node.new("parameter_list", "ParameterList"),
	Node.new("parameter", "Parameter"),
	Node.new("argument_shuffle_expr", "ArgumentShuffleExpr"),
]


def main
	template_files = ['Nodes.template', 'SyntaxVisitor.template']
	renderer = Renderer.new(NODES)
	generated_path = Pathname.new('../Generated')
	template_files.each do |file|
		erb = ERB.new(File.read(file))
		output = erb.result(renderer.get_binding)
		swift_filename = Pathname.new(file).sub_ext('.swift')
		swift_file = File.open(generated_path.join(swift_filename), 'w')
		swift_file.puts output
	end
end

main
