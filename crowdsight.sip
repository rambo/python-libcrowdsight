// Define the SIP wrapper to the hellosip library.

%Module crowdsight

enum OperationMode {
   DEVELOPER      = 0,
   REDISTRIBUTION = 1,
};

enum ColorSpace {
  RGB = 0, /*!< data is in RGB format */
  BGR,     /*!< data is in BGR format */
  YUV,     /*!< data is in YUV format */
  YUV420,  /*!< data is in YUV420 format, mainly used for Android cameras */
  BMP,     /*!< data is in BitMap format (RGB_8888), mainly used for Android cameras */
  BMP565   /*!< data is in BitMap format (RGB_565), mainly used for Android cameras */
};


class Person {

%TypeHeaderCode
#include <crowdsight.h>
#include "opencv2/core/types_c.h"
%End

public:
    Person();
    ~Person();
    int getID();
    int getAge();
    float getGender();
    std::vector<float> & getEthnicity( );
    cv::Rect getFaceRect();
    float getMood();
    float getHeadYaw();
    float getHeadPitch();
    float getHeadRoll();
    cv::Point getHeadGaze();
    std::vector<float> & getHeadPose();
    cv::Point getRightEye();
    cv::Point getLeftEye();
    int64_t getTime();
    int64_t firstSeen();
    int64_t getAttentionSpan();
    bool isReturningCustomer();
    std::vector< std::vector<int> > & getClothingColors(  );
    std::vector<float> & getEmotions( );
    std::vector<float> & getActionUnits( );
    std::vector<cv::Point> & getTrackingPoints();

};

class CrowdSight {

%TypeHeaderCode
#include <crowdsight.h>
#include "opencv2/core/types_c.h"
%End

public:
    CrowdSight( std::string datadir="/usr/local/crowdsight/data", OperationMode mode=DEVELOPER);
    ~CrowdSight();
    std::string getVersion();
    bool authenticate( const std::string & key,
                       const std::string & proxyAddress = "",
                       const int           proxyPort = 0,
                       const std::string & proxyUserName = "",
                       const std::string & proxyPassword = "" );
    int getRemainingCredits();
    bool process( const cv::Mat & image, const cv::vector<cv::Rect> & faces, bool singleImage = false );
    bool process( const cv::Mat & image, bool singleImage = false );
    bool getCurrentPeople( std::vector<Person> & people, const FeaturesRequest & features = ALL_FEATURES );
    void reset();
    int getPeopleCount();
    int getMaxNumPeople();
    const cv::Rect & getRoi();
    bool saveModel( int id, const std::string & fileName );
    int loadModel( const std::string & fileName );
    bool deleteModel( int id );
    int  createModel( const cv::Mat & img, const std::string & modelName, const cv::Rect & rect = cv::Rect(0, 0, 0, 0) );
    bool addToModel( int modelId, int observationId);
    bool addToModel( int id, const cv::Mat & img , const cv::Rect & rect = cv::Rect(0, 0, 0, 0));
    double compareModels( int id1, int id2 );
    bool identifyModel( int id, std::vector<int> & modelIds,std::vector<int> & foundIds, std::vector<float> & confidence, int topK = 1 );
    std::vector<int> getModels();
    std::vector<int> getModelsExcept(int excludedID);
    bool getLabel(int id, std::string & label);
    int getMinFaceSize();
    int getMaxFaceSize();
    int getFaceDetector();
    int getNumClothingColors();
    float getDetectionScale();
    float getRecognitionLevel();
    float getFaceConfidence();
    int getSmoothing();
    int getNumThreads();
    void setRecognitionLevel( float recognitionLevel );
    void setFaceConfidence( float faceConfidence );
    void setMinFaceSize( int minFaceSize );
    void setMaxFaceSize( int maxFaceSize );
    void setNumClothingColors( int n );
    void setSmoothing( int s );
    void setRoi( const cv::Rect & roi );
    bool setLabel( int id, const std::string label );
    void setFaceDetector( int num );
    void setDetectionScale( float num );
    void setMaxNumPeople( int maxNumPeople );
    void setNumThreads( int threads );
    void useFastDetection( bool use );
    void useTracking( bool use );
    void useNightMode( bool use );
    void useAsianMode( bool use );
    void useAge( bool use );
    void useGender( bool use );
    void useEthnicity( bool use );
    void useMood( bool use );
    void useHeadPose( bool use );
    void useClothColors( bool use );
    void useEmotions( bool use );
    bool isAgeUsed();
    bool isGenderUsed();
    bool isEthnicityUsed();
    bool isHeadPoseUsed();
    bool isMoodUsed();
    bool isEmotionsUsed();
    bool isClothingColorsUsed();
    bool isFastDetectionUsed();
    bool isTrackingUsed();
    bool isNightModeUsed();
    bool isAsianModeUsed();
    void saveSettings();
    int getErrorCode();
    const std::string & getErrorDescription();
    bool isAuthenticated();
    cv::Mat convert( void *data_array, int width, int height, ColorSpace colorSpace );

private:
    /* CrowdSight objects cannot be copied */
    CrowdSight( const CrowdSight & );
    CrowdSight & operator=( const CrowdSight & );
};


// Creates the mapping for std::string
// From: http://www.riverbankcomputing.com/pipermail/pyqt/2009-July/023533.html

%MappedType std::string
{
%TypeHeaderCode
#include <string>
%End

%ConvertFromTypeCode
    // convert an std::string to a Python (unicode) string
    PyObject* newstring;
    newstring = PyUnicode_DecodeUTF8(sipCpp->c_str(), sipCpp->length(), NULL);
    if(newstring == NULL) {
        PyErr_Clear();
        newstring = PyString_FromString(sipCpp->c_str());
    }
    return newstring;
%End

%ConvertToTypeCode
    // Allow a Python string (or a unicode string) whenever a string is
    // expected.
    // If argument is a Unicode string, just decode it to UTF-8
    // If argument is a Python string, assume it's UTF-8
    if (sipIsErr == NULL)
        return (PyString_Check(sipPy) || PyUnicode_Check(sipPy));
    if (sipPy == Py_None) {
        *sipCppPtr = new std::string;
        return 1;
    }
    if (PyUnicode_Check(sipPy)) {
        PyObject* s = PyUnicode_AsEncodedString(sipPy, "UTF-8", "");
        *sipCppPtr = new std::string(PyString_AS_STRING(s));
        Py_DECREF(s);
        return 1;
    }
    if (PyString_Check(sipPy)) {
        *sipCppPtr = new std::string(PyString_AS_STRING(sipPy));
        return 1;
    }
    return 0;
%End
};
