public with sharing virtual class DataProvider implements IDataProvider {
    public interface IDataProvider {
        void save(SObject obj);
        void save(List<SObject> objs);
        List<String> saveObjects(List<SObject> objs);
        void remove(SObject obj);
        void remove(List<SObject> objs);
        List<String> removeObjects(List<SObject> objs);
        List<DynamicQueryResult> executeDynamicQuery(String query, List<String> fieldNames);
    }

    public class DynamicQueryResult {
        public SObject sobj {get;set;}
        public List<DynamicQueryFieldResult> fieldValues {get;set;}
    }

    public class DynamicQueryFieldResult {
        public String fieldName {get;set;}
        public Object fieldValue {get;set;}
    }

    public void save(SObject obj) {
        save(new List<SObject>{ obj });
    }

    public void save(List<SObject> objs) {
        if (objs != null && objs.size() > 0) {
            List<SObject> inserts = new List<SObject>();
            List<SObject> updates = new List<SObject>();
            for (SObject o : objs) {
                if (String.isBlank(o.Id)) {
                    inserts.add(o);
                } else {
                    updates.add(o);
                }
            }

            if (inserts.size() > 0) {insert inserts;}
            if (updates.size() > 0) {update updates;}
        }       
    }

    public List<String> saveObjects(List<SObject> objs) {
        List<String> errors = new List<String>();
        List<SObject> inserts  = new List<SObject>();
        List<SObject> updates = new List<SObject>();
        for (SObject o : objs) {
            if (String.isBlank(o.Id)) {
                inserts.add(o);
            } else {
                updates.add(o);
            }
        }

        List<Database.SaveResult> insertResults = Database.insert(inserts, false);
        List<Database.SaveResult> updateResults = Database.update(updates, false);
        errors.addAll(getErrors(updateResults));
        errors.addAll(getErrors(insertResults));
        
        return errors;
    }

    private List<String> getErrors(List<Database.SaveResult> srList) {
        List<String> errors = new List<String>();
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    errors.add(err.getMessage());
                }
            }
        }

        return errors;
    }
    
    private List<String> getErrors(List<Database.DeleteResult> srList) {
        List<String> errors = new List<String>();
        for (Database.DeleteResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    errors.add(err.getMessage());
                }
            }
        }

        return errors;
    }

    public void remove(SObject obj) {
        remove(new List<SObject>{ obj });
    }

    public void remove(List<SObject> objs) {
        List<SObject> deletes = new List<SObject>();
        for (SObject s : objs) {
            if(String.isNotBlank(s.Id)) deletes.add(s);
        }
        delete deletes;
    }
    
    public List<String> removeObjects(List<SObject> objs) {
        List<SObject> deletes = new List<SObject>();
        List<String> errors = new List<String>();
        for (SObject s : objs) {
            if (String.isNotBlank(s.Id)) {
                deletes.add(s);
            }
        }
        List<Database.DeleteResult> deleteResults = Database.delete(deletes, false);
        errors.addAll(getErrors(deleteResults));
        return errors;
    }

    public List<DynamicQueryResult> executeDynamicQuery(String query, List<String> fieldNames) {
        List<SObject> sos = Database.query(query);
        List<DynamicQueryResult> results = new List<DynamicQueryResult>();
        for (SObject so : sos) {
            List<DynamicQueryFieldResult> soFields = new List<DynamicQueryFieldResult>();
            for (String fieldName : fieldNames) {
                DynamicQueryFieldResult fieldResult = new DynamicQueryFieldResult();
                fieldResult.fieldName = fieldName;
                fieldResult.fieldValue = getFieldValue(so, fieldName);
                soFields.add(fieldResult);
            }
            DynamicQueryResult result = new DynamicQueryResult();
            result.sobj = so;
            result.fieldValues = soFields;
            results.add(result);
        }
        return results;
    }

    private Object getFieldValue(SObject so, String fieldAsString) {
        List<String> fields = fieldAsString.split('\\.');
        Integer lastIndex = fields.size() - 1;
        SObject temp = so;
        for (Integer i=0 ; i<lastIndex; ++i) {
            temp = temp.getSObject(fields[i]);
        }

        if(temp == null) {return null;}
        return temp.get(fields[lastIndex]);
    }
}