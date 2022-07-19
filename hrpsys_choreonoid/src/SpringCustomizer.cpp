#include <stdlib.h>

#include <cmath>
#include <cstring>
#include <fstream>
#include <boost/function.hpp>
#include <boost/bind.hpp>
#include <yaml-cpp/yaml.h>

#define CNOID_BODY_CUSTOMIZER
#ifdef CNOID_BODY_CUSTOMIZER
#include <cnoid/BodyCustomizerInterface>
#else
#include <BodyCustomizerInterface.h>
#endif

#include <iostream>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
#define DLL_EXPORT __declspec(dllexport)
#else
#define DLL_EXPORT
#endif /* Windows */

#if defined(HRPMODEL_VERSION_MAJOR) && defined(HRPMODEL_VERSION_MINOR)
#if HRPMODEL_VERSION_MAJOR >= 3 && HRPMODEL_VERSION_MINOR >= 1
#include <hrpUtil/Tvmet3dTypes.h>
#define NS_HRPMODEL hrp
#endif
#endif

#ifdef CNOID_BODY_CUSTOMIZER
#define NS_HRPMODEL cnoid
cnoid::Matrix3 trans(const cnoid::Matrix3& M) { return M.transpose(); }
double dot(const cnoid::Vector3& a, const cnoid::Vector3& b) { return a.dot(b); }
typedef cnoid::Matrix3 Matrix33;
#endif


#ifndef NS_HRPMODEL
#define NS_HRPMODEL OpenHRP
typedef OpenHRP::vector3 Vector3;
typedef OpenHRP::matrix33 Matrix33;
#endif

using namespace std;
using namespace boost;
using namespace NS_HRPMODEL;

static BodyInterface* bodyInterface = 0;

static BodyCustomizerInterface bodyCustomizerInterface;

struct JointInfo
{
    std::string name;
    double K;
    double D;
    double upper_limit;
    double lower_limit;
};
struct JointValSet
{
    double* valuePtr;
    double* velocityPtr;
    double* torqueForcePtr;
    // JointInfo
    std::string name;
    double K;
    double D;
    double upper_limit;
    double lower_limit;
};

struct SpringCustomizer
{
    BodyHandle bodyHandle;

    std::vector<JointValSet > jointValSets;
};


static const char** getTargetModelNames()
{
    char *rname = getenv("CHOREONOID_ROBOT");
    if (rname != NULL) {
        std::cerr << "CHOREONID_ROBOT =" << rname << std::endl;
    }
    static const char* names[] = {
        rname,
        0 };

    return names;
}

static BodyCustomizerHandle create(BodyHandle bodyHandle, const char* modelName)
{
    SpringCustomizer* customizer = 0;

    std::cerr << "create SpringCustomizer : " << std::string(modelName) << std::endl;
    customizer = new SpringCustomizer;

    customizer->bodyHandle = bodyHandle;

    char* config_file_path = getenv("SPRING_CUSTOMIZER_CONF_FILE");
    if (config_file_path) {
        ifstream ifs(config_file_path);
        if (ifs.is_open()) {
            JointValSet vs;
            std::cerr << "[SpringCustomizer] Config file is: " << config_file_path << std::endl;
            YAML::Node param = YAML::LoadFile(config_file_path);
            try {
                YAML::Node sp_lst = param["springs"];// list
                for(int i = 0; i < sp_lst.size(); i++) {
                    const YAML::Node &sp = sp_lst[i];

                    vs.name = sp["joint_name"].as<std::string>();
                    vs.K = sp["K"].as<double>();
                    vs.D = sp["D"].as<double>();
                    vs.upper_limit = sp["upper_limit"].as<double>();
                    vs.lower_limit = sp["lower_limit"].as<double>();

                    int index = bodyInterface->getLinkIndexFromName(bodyHandle, vs.name.c_str());
                    if (index < 0) {
                        std::cerr << "[SpringCustomizer] failed to find joint: " << vs.name << std::endl;
                        continue;
                    }
                    vs.valuePtr = bodyInterface->getJointValuePtr(bodyHandle, index);
                    vs.velocityPtr = bodyInterface->getJointVelocityPtr(bodyHandle, index);
                    vs.torqueForcePtr = bodyInterface->getJointForcePtr(bodyHandle, index);

                    customizer->jointValSets.push_back(vs);
                }
            } catch (YAML::Exception &e) {
                std::cerr << "[SpringCustomizer] yaml read error: " << e.what() << std::endl;
            }
        } else {
            std::cerr << "[SpringCustomizer] " << config_file_path << " is not found" << std::endl;
        }
    }

    return static_cast<BodyCustomizerHandle>(customizer);
}


static void destroy(BodyCustomizerHandle customizerHandle)
{
    SpringCustomizer* customizer = static_cast<SpringCustomizer*>(customizerHandle);
    if(customizer){
        delete customizer;
    }
}

static void setVirtualJointForces(BodyCustomizerHandle customizerHandle)
{
    SpringCustomizer* customizer = static_cast<SpringCustomizer*>(customizerHandle);

    for(int i=0; i < customizer->jointValSets.size(); ++i) {
        JointValSet& trans = customizer->jointValSets[i];
        *(trans.torqueForcePtr) = - trans.K * (*trans.valuePtr) - trans.D * (*trans.velocityPtr);
    }
}

extern "C" DLL_EXPORT
NS_HRPMODEL::BodyCustomizerInterface* getHrpBodyCustomizerInterface(NS_HRPMODEL::BodyInterface* bodyInterface_)
{
  bodyInterface = bodyInterface_;

  bodyCustomizerInterface.version = NS_HRPMODEL::BODY_CUSTOMIZER_INTERFACE_VERSION;
  bodyCustomizerInterface.getTargetModelNames = getTargetModelNames;
  bodyCustomizerInterface.create = create;
  bodyCustomizerInterface.destroy = destroy;
  bodyCustomizerInterface.initializeAnalyticIk = NULL;
  bodyCustomizerInterface.calcAnalyticIk = NULL;
  bodyCustomizerInterface.setVirtualJointForces = setVirtualJointForces;

  return &bodyCustomizerInterface;
}
