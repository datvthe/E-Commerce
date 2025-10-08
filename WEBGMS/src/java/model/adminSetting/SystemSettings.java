/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.adminSetting;

public class SystemSettings {

    private int settingId;
    private String name;
    private String value;
    private String type;        // ENUM: string, int, json, bool
    private String description;

    public SystemSettings() {
    }

    public SystemSettings(int settingId, String name, String value, String type, String description) {
        this.settingId = settingId;
        this.name = name;
        this.value = value;
        this.type = type;
        this.description = description;
    }

    public int getSettingId() {
        return settingId;
    }

    public void setSettingId(int settingId) {
        this.settingId = settingId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "SystemSettings{" + "settingId=" + settingId + ", name=" + name + ", value=" + value + ", type=" + type + ", description=" + description + '}';
    }

}
