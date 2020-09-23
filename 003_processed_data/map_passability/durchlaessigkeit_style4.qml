<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" readOnly="0" maxScale="0" simplifyDrawingHints="1" minScale="1e+08" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" styleCategories="AllStyleCategories" simplifyDrawingTol="1" simplifyLocal="1" version="3.10.5-A Coruña" simplifyMaxScale="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" type="RuleRenderer" enableorderby="0" forceraster="0">
    <rules key="{5522a296-38e3-4914-9ea1-7f21d260e3d2}">
      <rule symbol="0" key="{4d45a8d5-19ae-461a-92b2-de800c2bbb48}" filter=" &quot;evaled&quot;  =  0"/>
      <rule symbol="1" key="{a98c19d0-f6e3-4a51-bdb1-0dc20f36165d}" filter=" &quot;evaled&quot;  = 1 AND  &quot;score_down_eval&quot;  = 1"/>
      <rule symbol="2" key="{c45e53ca-17ca-41df-91b8-8c40ffa02ff1}" filter=" &quot;evaled&quot;  = 1 AND  &quot;score_down_eval&quot;  &lt; 1 AND &quot;score_down_eval&quot; >= .66"/>
      <rule symbol="3" key="{001453b2-ae7e-4dfc-9b59-72c1f788c61b}" filter=" &quot;evaled&quot;  = 1 AND  &quot;score_down_eval&quot;  &lt;  0.66  AND  &quot;score_down_eval&quot;  >=  0.50"/>
      <rule symbol="4" key="{1a4a0f22-fea7-4178-86b3-1067fa5a1f6a}" filter=" &quot;evaled&quot;  = 1 AND  &quot;score_down_eval&quot;  &lt;  0.50  AND  &quot;score_down_eval&quot;  >=  0.33"/>
      <rule symbol="5" key="{bd0d4017-5e4e-40d4-8288-08d69e667730}" filter=" &quot;evaled&quot;  = 1 AND  &quot;score_down_eval&quot;  &lt;  0.33 AND &quot;score_down_eval&quot; > 0"/>
      <rule symbol="6" key="{6cfc3384-7df4-41db-863e-386697aa4581}" filter=" &quot;evaled&quot;  = 1 AND  &quot;score_down_eval&quot;  = 0"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="0" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="191,191,191,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.1" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="1" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="44,185,37,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="2" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="143,255,69,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="3" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="242,226,44,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="4" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="251,172,13,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="5" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="255,86,1,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" name="6" alpha="1">
        <layer locked="0" class="SimpleLine" enabled="1" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="212,0,0,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property value="&quot;fid&quot;" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory penWidth="0" maxScaleDenominator="1e+08" opacity="1" width="15" penAlpha="255" rotationOffset="270" penColor="#000000" lineSizeScale="3x:0,0,0,0,0,0" enabled="0" labelPlacementMethod="XHeight" diagramOrientation="Up" minimumSize="0" minScaleDenominator="0" scaleDependency="Area" sizeType="MM" backgroundColor="#ffffff" sizeScale="3x:0,0,0,0,0,0" barWidth="5" lineSizeType="MM" height="15" scaleBasedVisibility="0" backgroundAlpha="255">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" obstacle="0" zIndex="0" dist="0" placement="2" priority="0" linePlacementFlags="18">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="fid">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="ecoserv_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="FROM">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="TO">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="score_up">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="score_down">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="score_up_eval">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="score_down_eval">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="evaled">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="row_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="fid" name="" index="0"/>
    <alias field="ecoserv_id" name="" index="1"/>
    <alias field="FROM" name="" index="2"/>
    <alias field="TO" name="" index="3"/>
    <alias field="score_up" name="" index="4"/>
    <alias field="score_down" name="" index="5"/>
    <alias field="score_up_eval" name="" index="6"/>
    <alias field="score_down_eval" name="" index="7"/>
    <alias field="evaled" name="" index="8"/>
    <alias field="row_id" name="" index="9"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="fid"/>
    <default applyOnUpdate="0" expression="" field="ecoserv_id"/>
    <default applyOnUpdate="0" expression="" field="FROM"/>
    <default applyOnUpdate="0" expression="" field="TO"/>
    <default applyOnUpdate="0" expression="" field="score_up"/>
    <default applyOnUpdate="0" expression="" field="score_down"/>
    <default applyOnUpdate="0" expression="" field="score_up_eval"/>
    <default applyOnUpdate="0" expression="" field="score_down_eval"/>
    <default applyOnUpdate="0" expression="" field="evaled"/>
    <default applyOnUpdate="0" expression="" field="row_id"/>
  </defaults>
  <constraints>
    <constraint constraints="3" exp_strength="0" notnull_strength="1" field="fid" unique_strength="1"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="ecoserv_id" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="FROM" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="TO" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="score_up" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="score_down" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="score_up_eval" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="score_down_eval" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="evaled" unique_strength="0"/>
    <constraint constraints="0" exp_strength="0" notnull_strength="0" field="row_id" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" field="fid" exp=""/>
    <constraint desc="" field="ecoserv_id" exp=""/>
    <constraint desc="" field="FROM" exp=""/>
    <constraint desc="" field="TO" exp=""/>
    <constraint desc="" field="score_up" exp=""/>
    <constraint desc="" field="score_down" exp=""/>
    <constraint desc="" field="score_up_eval" exp=""/>
    <constraint desc="" field="score_down_eval" exp=""/>
    <constraint desc="" field="evaled" exp=""/>
    <constraint desc="" field="row_id" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
    <columns>
      <column type="field" hidden="0" width="-1" name="fid"/>
      <column type="field" hidden="0" width="-1" name="FROM"/>
      <column type="field" hidden="0" width="-1" name="TO"/>
      <column type="field" hidden="0" width="-1" name="score_up"/>
      <column type="field" hidden="0" width="-1" name="score_down"/>
      <column type="field" hidden="0" width="-1" name="score_up_eval"/>
      <column type="field" hidden="0" width="-1" name="score_down_eval"/>
      <column type="field" hidden="0" width="-1" name="evaled"/>
      <column type="actions" hidden="1" width="-1"/>
      <column type="field" hidden="0" width="-1" name="row_id"/>
      <column type="field" hidden="0" width="-1" name="ecoserv_id"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="ABSCHNITT"/>
    <field editable="1" name="FROM"/>
    <field editable="1" name="TO"/>
    <field editable="1" name="ecoserv_id"/>
    <field editable="1" name="evaled"/>
    <field editable="1" name="fid"/>
    <field editable="1" name="row_id"/>
    <field editable="1" name="score_down"/>
    <field editable="1" name="score_down_eval"/>
    <field editable="1" name="score_up"/>
    <field editable="1" name="score_up_eval"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="ABSCHNITT"/>
    <field labelOnTop="0" name="FROM"/>
    <field labelOnTop="0" name="TO"/>
    <field labelOnTop="0" name="ecoserv_id"/>
    <field labelOnTop="0" name="evaled"/>
    <field labelOnTop="0" name="fid"/>
    <field labelOnTop="0" name="row_id"/>
    <field labelOnTop="0" name="score_down"/>
    <field labelOnTop="0" name="score_down_eval"/>
    <field labelOnTop="0" name="score_up"/>
    <field labelOnTop="0" name="score_up_eval"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>fid</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
