public with sharing class ParentRelationshipTree { //change this to wrapper
	    public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        public String nodeLevel{
        	get{
                return String.valueOf(nodeId.countMatches('.')); 
        	}
        }
        
        
        public String nodeStyle{
        	get{
        		String styles = '';
        		if(currentNode == true){
        			styles +=' currentNode';  
                   }
                else {
                     styles += String.valueOf(nodeLevel);
                }
        		
        		return styles;
        	}
        }
               
        public Account account;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }
        public String getnodeStyle() {return nodeStyle;}

        public Account getaccount() { return account; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }
        public void setaccount( Account a ) { this.account = a; }

        public ParentRelationshipTree( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a ){
            
            setnodeId(nodeId);
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            setnodeType(nodeType);
            setcurrentNode(currentNode);
            setaccount(a);
        }
}