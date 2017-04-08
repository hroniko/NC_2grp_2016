package entities;

/**
 * Created by Hroniko on 31.01.2017.
 */
import dbHelp.DBHelp;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;

public class Event extends BaseEntitie{

    public static final int objTypeID = 1002;

    private int id; // 1
    private int host_id; // 141
    private String name; // 3
    private String date_begin; // 101
    private String date_end; // 102
    private String priority; // 105
    private String info; // 104
    private String duration; // еще продолжительность 103


    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getHost_id() {
        return host_id;
    }

    public void setHost_id(int host_id) {
        this.host_id = host_id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getDate_begin() throws ParseException {

        return date_begin;
    }
    public void setDate_begin(String data_begin) { this.date_begin = data_begin; }

    public String getDate_end() { return date_end; }
    public void setDate_end(String data_end) { this.date_end = data_end; }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public Event() {}

    public Event(String name, String date_begin, String date_end, String duration, String priority, String info) {
        this.name = name;
        this.date_begin = date_begin;
        this.date_end = date_end;
        this.duration = duration;
        this.priority = priority;
        this.info = info;

    }

    public Event(DataObject dataObject) throws SQLException, NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        this.id = dataObject.getId();
        // Поле params
        for (Map.Entry<Integer, String> param : dataObject.getParams().entrySet() ) {
            switch (param.getKey()){
                case (101):
                    this.date_begin = param.getValue();
                    break;
                case (102):
                    this.date_end = param.getValue();
                    break;
                case (103):
                    this.duration = param.getValue();// duration
                    break;
                case (105):
                    this.priority = param.getValue();
                    break;
                case (104):
                    this.info = param.getValue();
                    break;
            }
            this.name = dataObject.getName();
        }
    }

    public DataObject toDataObject(){
        DataObject dataObject = new DataObject();
        dataObject.setId(this.id);
        dataObject.setObjectTypeId(objTypeID);
        dataObject.setName(this.name);
        dataObject.setParams(101, this.date_begin);
        dataObject.setParams(102, this.date_end);
        dataObject.setParams(103, this.duration);
        dataObject.setParams(104, this.info);
        dataObject.setParams(105, this.priority);
        return dataObject;
    }

    public TreeMap<Integer, Object> getArrayWithAttributes(){
        TreeMap<Integer, Object> map = new TreeMap<>();
        map.put(101, date_begin);
        map.put(102, date_end);
        map.put(103, duration); // Продолжительность события. Пока что так, потом исправить, вставить расчет.      Исправлено!
        map.put(104, info);
        map.put(105, priority);
        return map;
    }

}
