import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;


public class Parsing {
    public static void main(String[] args) throws FileNotFoundException {
        //specify file for the output
        File file = new File("DiseasesAndTestsFinal.txt");
        FileOutputStream fos = new FileOutputStream(file);
        PrintStream ps = new PrintStream(fos);
        System.setOut(ps);

        try {
            //specify file for parsing
            File inputFile = new File("gtr.txt");
            SAXParserFactory factory = SAXParserFactory.newInstance();
            SAXParser saxParser = factory.newSAXParser();
            UserHandler userhandler = new UserHandler();
            saxParser.parse(inputFile, userhandler);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}



class UserHandler extends DefaultHandler {

    //intitialize and set all variables to false
    boolean ClinVarName = false;
    boolean institution = false;
    boolean country = false;
    boolean city = false;
    boolean state = false;
    boolean name = false;
    boolean xref = false;
    boolean testName = false;
    boolean postcode = false;


    @Override
    public void startElement(String uri,
                             String localName, String qName, Attributes attributes)
            throws SAXException {

        Tell user when program finds the element "TraitSet"
       if (qName.equalsIgnoreCase("TraitSet")) {
           System.out.print("Trait set(disease ID):" + "     #     ");
       }
       if (qName.equalsIgnoreCase("TraitSet")) {
           System.out.print("Beginning Trait set! (disease ID)" + "     #     ");
       }
       if (qName.equalsIgnoreCase("Measureset")) {
           System.out.print("Measure set(gene ID):" + "     #     ");
       }

        if (qName.equalsIgnoreCase("trait")) {
            String diseaseID = attributes.getValue("ID");
        } else if (qName.equalsIgnoreCase("name")) {
            name = true;
        }
        //retrieve attribute value from element
        if (qName.equalsIgnoreCase("xref")) {
            String Database = attributes.getValue("DB");
            String DatabaseID = attributes.getValue("ID");
            System.out.print("Database: " + Database + "     #     ");
            System.out.print("Database ID: " + DatabaseID + "     #     ");
        }
        if (qName.equalsIgnoreCase("testname")) {
            testName = true;
        }

   @Override
   public void endElement(String uri,
                          String localName, String qName) throws SAXException {
       if (qName.equalsIgnoreCase("GTRLabData")) {
           System.out.println("End Element for the lab.");
       }
       if (qName.equalsIgnoreCase("TraitSet")) {
           System.out.println("End of Trait set!");
       }
       if (qName.equalsIgnoreCase("Measureset")) {
           System.out.println("End of Measure set!");
       }
   }


    }

        @Override
        public void characters ( char ch[],
        int start, int length) throws SAXException {
       if (xref) {
           System.out.println("XRef: "
                   + new String(ch, start, length));
           xref = false;
       }
        if (testName) {
            System.out.print("Test Name: "
                    + new String(ch, start, length) + "     #     ");
            testName = false;
        }
        }

//    @Override
    public void endElement(String uri,
                           String localName, String qName) throws SAXException {
        if (qName.equalsIgnoreCase("TestName")) {
            System.out.println("");
        }
    }
}