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
        if (qName.equalsIgnoreCase("ClinVarSourceName")) {
            ClinVarName = true;
        }
        if (qName.equalsIgnoreCase("institution")) {
            institution = true;
        }
        if (qName.equalsIgnoreCase("city")) {
            city = true;
        }
        if (qName.equalsIgnoreCase("state")) {
            state = true;
        }
        if (qName.equalsIgnoreCase("Postcode")) {
            postcode = true;
        }
        if (qName.equalsIgnoreCase("country")) {
            country = true;
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

    }

        @Override
        public void characters ( char ch[],
        int start, int length) throws SAXException {
            if (institution == true) {
                System.out.print(("Laboratory Name: " + new String(ch, start, length)) + "     #     ");
                institution = false;
            }
            if (ClinVarName == true) {
                System.out.print(("Laboratory Name: " + new String(ch, start, length)) + "     #     ");
                ClinVarName = false;
            }
            if (city) {
                System.out.print(("City Name: " + new String(ch, start, length)) + "     #     ");
                city = false;
            }
            if (state) {
                System.out.print(("State Name: " + new String(ch, start, length)) + "     #     ");
                state = false;
            }
            if (postcode) {
                System.out.print(("PostCode Digit: " + new String(ch, start, length)) + "     #     ");
                postcode = false;
            }
            if (country) {
                System.out.print(("Country Name: " + new String(ch, start, length))+ "     #     ");
                country = false;
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